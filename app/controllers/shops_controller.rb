class ShopsController < ApplicationController
  def index
    keyword = params[:keyword].presence || "居酒屋"
    params[:start] = params[:start].to_i
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
    # params[:start] == 0(ページ遷移の時) または同じ条件で検索しているかつ次の100件じゃない時データベースから取得
    unless params[:start] == 0 || (params[:start] == 1 && keyword_filter.present?)
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
    @shops = Shop.filter_or_keyword_association(filters, @keyword)
    # ページネーション
    @current_page = (params[:page].to_i > 0) ? params[:page].to_i : 1
    @total_shops = @shops.count
    @total_page = (@total_shops.to_f / 10).ceil
    @shops = @shops.offset((@current_page - 1) * Shop::PAGE_NUMBER).limit(Shop::PAGE_NUMBER)
    @previous_page = @current_page > 1 ? @current_page - 1 : nil
    @next_page = @total_page > @current_page ? @current_page + 1 : nil
    @first_page = @current_page > 1 ?  1 : nil
    @last_page = @total_page > @current_page ? @total_page : nil
    @start_page = [ @current_page - 3, 1 ].max
    @final_page = [ @current_page + 3, @total_page ].min
  end

  def show
    @shop = Shop.find(params[:id])
  end

  private

  def search_params(keyword)
    params.permit(:keyword, :start, :free_drink, :free_food, :private_room, :course, :midnight, :non_smoking)
          .to_h # ハッシュ化
          .symbolize_keys # キーを文字列からキーに変更
          .merge(keyword: keyword,
                 free_drink: params[:free_drink].presence || 0,
                 free_food: params[:free_food].presence || 0,
                 private_room: params[:private_room].presence || 0,
                 course: params[:course].presence || 0,
                 midnight: params[:midnight].presence || 0,
                 non_smoking: params[:non_smoking].presence || 0,
                 start: params[:start].to_i
          )
  end

  def shops_create(keyword)
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
    end
  end
end
