class ShopsController < ApplicationController
  def index
    shop_ids = params[:shop_ids].presence || []
    keyword = params[:keyword].presence || "居酒屋"
    params[:record_start_index] = params[:record_start_index].to_i
    current_location_search = params[:current_location].to_i
    current_latitude = params[:latitude].to_f
    current_longitude = params[:longitude].to_f
    @keyword = Keyword.find_or_create_keyword(keyword)
    filter_condition = {
      free_drink: params[:free_drink].to_i,
      free_food: params[:free_food].to_i,
      private_room: params[:private_room].to_i,
      course: params[:course].to_i,
      midnight: params[:midnight].to_i,
      non_smoking: params[:non_smoking].to_i
    }
    filter = Filter.find_or_create(filter_condition)
    # Keyword_filtersテーブルにこのKeywordとFilterの組み合わせのデータがあるかどうかを確認したい
    keyword_filter = KeywordFilter.find_association(@keyword, filter)
    # params[:start] == 0(ページ遷移の時) または同じ条件で検索しているかつ次の100件じゃない時または現在地検索がONの時データベースから取得
    unless params[:record_start_index] == 0 || params[:record_start_index] == 1 && keyword_filter.present? && current_location_search == 0
      @API_shop_data = HotpepperApi.search_shops(**search_params(keyword))
      shops_create(@keyword, shop_ids)
      KeywordFilter.find_or_create_association(@keyword, filter)
    end

    # データベース内検索の条件
    @filter_conditions = {}
    @filter_conditions[:free_drink] = params[:free_drink] if params[:free_drink]
    @filter_conditions[:free_food] = params[:free_food] if params[:free_food]
    @filter_conditions[:private_room] = params[:private_room] if params[:private_room]
    @filter_conditions[:course] = params[:course] if params[:course]
    @filter_conditions[:midnight] = params[:midnight] if params[:midnight]
    @filter_conditions[:non_smoking] = params[:non_smoking] if params[:non_smoking]

    filters = Filter.where(@filter_conditions)
    # @shopにデータベース内検索結果を格納
    if current_location_search == 1
      placeholders = shop_ids.map { "?" }.join(", ")
      query = ActiveRecord::Base.sanitize_sql_array([ "FIELD(unique_number, #{placeholders})", *shop_ids ])
      shops = Shop.where(unique_number: shop_ids).order(Arel.sql(query))
    else
      shops = Shop.filter_and_keyword_association(filters, @keyword)
    end
    # ページネーション
    @keyword_filter_params = @filter_conditions.merge(keyword: @keyword.word, current_location: current_location_search, shop_ids: shop_ids, latitude: current_latitude, longitude: current_longitude)
    @current_page = (params[:page].to_i > 0) ? params[:page].to_i : 1
    @total_shops = shops.count
    @total_page = (@total_shops.to_f / Shop::PAGE_NUMBER).ceil
    @shops = shops.offset((@current_page - 1) * Shop::PAGE_NUMBER).limit(Shop::PAGE_NUMBER)

    if @shops.empty? && @current_page > 1
      @current_page = @total_page
      @shops = shops.offset((@current_page - 1) * Shop::PAGE_NUMBER).limit(Shop::PAGE_NUMBER)
      flash[:alert] = "検索結果はこれ以上ありません"
    end

    @previous_page = @current_page > 1 ? @current_page - 1 : nil
    @next_page = @total_page > @current_page ? @current_page + 1 : nil
    @first_page = @current_page > 1 ?  1 : nil
    @last_page = @total_page > @current_page ? @total_page : nil
    @start_page = [ @current_page - Shop::DISPLAY_PAGE_RUNGE, 1 ].max
    @final_page = [ @current_page + Shop::DISPLAY_PAGE_RUNGE, @total_page ].min
  end
  def show
    @shop = Shop.find(params[:id])
    @comment = @shop.comments.new
    @comments = @shop.comments.includes(:user)
    @bookmark = @shop.bookmarks.find_by(user_id: current_user.id)
  end

  private

  def search_params(keyword)
    params.permit(:keyword, :record_start_index, :free_drink, :free_food, :private_room, :course, :midnight, :non_smoking, :lat, :lng)
          .to_h # ハッシュ化
          .symbolize_keys # キーを文字列からキーに変更
          .merge(keyword: keyword,
                 free_drink: params[:free_drink].to_i,
                 free_food: params[:free_food].to_i,
                 private_room: params[:private_room].to_i,
                 course: params[:course].to_i,
                 midnight: params[:midnight].to_i,
                 non_smoking: params[:non_smoking].to_i,
                 record_start_index: params[:record_start_index].to_i,
                 lat: params[:latitude].to_f,
                 lng: params[:longitude].to_f
          )
  end

  def shops_create(keyword, shop_ids)
    @API_shop_data.each do |shop_data|
      # APIから取得した絞り込み条件に対応するデータをtrue/falseに変換
      filter_condition = {
      free_drink: shop_data["free_drink"].to_s.include?("あり"),
      free_food: shop_data["free_food"].to_s.include?("あり"),
      private_room: shop_data["private_room"].to_s.include?("あり"),
      course: shop_data["course"].to_s.include?("あり"),
      midnight: shop_data["midnight"].to_s.include?("営業している"),
      non_smoking: shop_data["non_smoking"].to_s.include?("ない")
      }
      # 条件にあうデータがfiltersテーブルにあったらfilterに格納、なければ作成
      filter = Filter.find_or_create(filter_condition)
      # shopsテーブルにすでに保存してある場合は更新、なければ作成
      shop = Shop.create_or_update_from_API_data(shop_data, filter)
      # ShopsとKeywordsの組み合わせが存在しなかったら作成
      ShopKeyword.find_or_create_association(shop, keyword)
      shop_ids << shop.unique_number
    end
  end
end
