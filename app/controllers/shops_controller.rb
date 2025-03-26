class ShopsController < ApplicationController
  def index
    @shop_ids = params[:shop_ids]
    keyword = params[:keyword]
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
      shops_create(@keyword)
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
      @shop_ids = params[:shop_ids] if @shop_ids == []
      placeholders = @shop_ids.map { "?" }.join(", ")
      query = ActiveRecord::Base.sanitize_sql_array([ "FIELD(unique_number, #{placeholders})", *@shop_ids ])
      shops = Shop.where(unique_number: @shop_ids).order(Arel.sql(query))
    else
      shops = Shop.filter_and_keyword_association(filters, @keyword)
    end
    # ページネーション
    @keyword_filter_params = @filter_conditions.merge(keyword: @keyword.word, current_location: current_location_search, shop_ids: @shop_ids, latitude: current_latitude, longitude: current_longitude)
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

  def shops_create(keyword)
    # APIから取得した絞り込み条件に対応するデータをtrue/falseに変換
    # まとめてINSERTするためにデータを配列に格納
    filter_conditions = @API_shop_data.map do |shop_data| {
      free_drink: shop_data["free_drink"].to_s.include?("あり"),
      free_food: shop_data["free_food"].to_s.include?("あり"),
      private_room: shop_data["private_room"].to_s.include?("あり"),
      course: shop_data["course"].to_s.include?("あり"),
      midnight: shop_data["midnight"].to_s.include?("営業している"),
      non_smoking: shop_data["non_smoking"].to_s.include?("ない")
      }
    end
    Filter.insert_filter_condition(filter_conditions)
    # Filterテーブルの指定したカラムデータをfiltersに格納
    filters = Filter.pluck(:free_drink, :free_food, :private_room, :course, :midnight, :non_smoking, :id)
    # filter_mapの要素を2つに変更(キーとバリュー)
    filter_map = filters.map { |filter| [ filter[0..5], filter[6] ] }.to_h
    shops_data = @API_shop_data.map do |shop_data|
      filter_id = filter_map[
        [
         shop_data["free_drink"].to_s.include?("あり"),
         shop_data["free_food"].to_s.include?("あり"),
         shop_data["private_room"].to_s.include?("あり"),
         shop_data["course"].to_s.include?("あり"),
         shop_data["midnight"].to_s.include?("営業している"),
         shop_data["non_smoking"].to_s.include?("ない")
        ]
      ]
      {
        unique_number: shop_data["id"],
        name: shop_data["name"],
        address: shop_data["address"],
        phone_number: shop_data["tel"],
        access: shop_data["access"],
        closing_day: shop_data["close"],
        budget: shop_data.dig("budget", "average"),
        number_of_seats: shop_data["capacity"],
        url: shop_data.dig("urls", "pc"),
        logo_image: shop_data["logo_image"],
        image: shop_data.dig("photo", "pc", "l"),
        filter_id: filter_id
      }
    end
    @shop_ids = @API_shop_data.map { |shop_data| shop_data["id"] }

    # APIから取得した店舗情報を新規登録or更新
    Shop.upsert_from_API_data(shops_data)
    shops = Shop.where(unique_number: @shop_ids).pluck(:id)
    shop_keyword_data = shops.map do |shop| {
      shop_id: shop,
      keyword_id: keyword.id
      }
    end
    ShopKeyword.bulk_insert(shop_keyword_data)
  end
end
