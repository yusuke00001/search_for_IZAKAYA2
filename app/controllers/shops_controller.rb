class ShopsController < ApplicationController
  def index
    params["keyword"] = "居酒屋" if params["keyword"].blank?
    params[:start] = params[:start].to_i
    # Keyword_filtersテーブルにこのKeywordとFilterの組み合わせのデータがあるかどうかを確認したい
    keyword_filter = KeywordFilter.joins(:keyword, :filter)
                                  .find_by(keywords: { word: params[:keyword] },
                                           filters: { free_drink: params[:free_drink].to_i,
                                                      free_food: params[:free_food].to_i,
                                                      private_room: params[:private_room].to_i,
                                                      course: params[:course].to_i,
                                                      midnight: params[:midnight].to_i,
                                                      non_smoking: params[:non_smoking].to_i
                                                    }
                                  )
    # params[:start] == 0(ページ遷移の時) または同じ条件で検索しているかつ次の100件じゃない時データベースから取得
    unless params[:start] == 0 || (params[:start] == 1 && keyword_filter.present?)
      @API_shop_data = HotpepperApi.search_shops(**search_params)
      word = params["keyword"]
      @keyword = Keyword.find_or_create_by!(word: word)
      shops_create(@keyword)
    end
    filter_conditions = {}
    filter_conditions[:free_drink] = 1 if params["free_drink"].to_i == 1
    filter_conditions[:free_food] = 1 if params["free_food"].to_i == 1
    filter_conditions[:private_room] = 1 if params["private_room"].to_i == 1
    filter_conditions[:course] = 1 if params["course"].to_i == 1
    filter_conditions[:midnight] = 1 if params["midnight"].to_i == 1
    filter_conditions[:non_smoking] = 1 if params["non_smoking"].to_i == 1
    @keyword = Keyword.find_by(word: params["keyword"])
    filters = Filter.where(filter_conditions)
    @shops = Shop.joins(:filters, :keywords)
                    .where(filters: { id: filters.ids },
                           keywords: { word: params["keyword"] })
    @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(Shop::PAGE_NUMBER)
  end

  private

  def search_params
    params.permit(:keyword, :start, :free_drink, :free_food, :private_room, :course, :midnight, :non_smoking)
          .to_h # ハッシュ化
          .symbolize_keys # キーを文字列からキーに変更
          .merge(keyword: params[:keyword],
                 free_drink: params[:free_drink].presence || 0,
                 free_food: params[:free_food].presence || 0,
                 private_room: params[:private_room].presence || 0,
                 course: params[:course].presence || 0,
                 midnight: params[:midnight].presence || 0,
                 non_smoking: params[:non_smoking].presence || 0,
                 start: params[:start].to_i
          ).tap { |search_params| }
  end

  def filter_params
    params.permit(:keyword, :free_drink, :free_food, :private_room, :course, :midnight, :non_smoking)
  end

  def check_box_params_convert
    {
      free_drink: params[:free_drink] == "あり" ? 1 : 0,
      free_food: params[:free_food] == "あり" ? 1 : 0,
      private_room: params[:private_room] == "あり" ? 1 : 0,
      course: params[:course] == "あり" ? 1 : 0,
      midnight: params[:midnight] == "営業している" ? 1 : 0,
      non_smoking: params[:non_smoking] == "なし" ? 0 : 1
    }
  end

  def shops_create(keyword)
    @API_shop_data.each do |shop_data|
      shop = Shop.find_by(unique_number: shop_data["id"])
      if shop
        shop.update!(
          name: shop_data["name"],
          address: shop_data["address"],
          phone_number: shop_data["tel"],
          access: shop_data["access"],
          closing_day: shop_data["close"],
          budget: shop_data["budget"],
          number_of_seats: shop_data["capacity"],
          url: shop_data["urls"],
          logo_image: shop_data["logo_image"],
          image: shop_data["photo"]
        )
        shop = Shop.find_by(unique_number: shop_data["id"])
      else
        shop = Shop.create!(
          unique_number: shop_data["id"],
          name: shop_data["name"],
          address: shop_data["address"],
          phone_number: shop_data["tel"],
          access: shop_data["access"],
          closing_day: shop_data["close"],
          budget: shop_data["budget"],
          number_of_seats: shop_data["capacity"],
          url: shop_data["urls"],
          logo_image: shop_data["logo_image"],
          image: shop_data["photo"]
        )
      end

    # APIから取得した絞り込み条件に対応するデータを0 or 1 に変換
    free_drink = shop_data["free_drink"].to_s.include?("あり") ? 1 : 0
    free_food = shop_data["free_food"].to_s.include?("あり") ? 1 : 0
    private_room = shop_data["private_room"].to_s.include?("あり") ? 1 : 0
    course = shop_data["course"].to_s.include?("あり") ? 1 : 0
    midnight = shop_data["midnight"].to_s.include?("営業している") ? 1 : 0
    non_smoking = shop_data["non_smoking"].to_s.include?("ない") ? 1 : 0

    # 条件にあうデータがfiltersテーブルにあったらfilterに格納、なかったら作成
    @filter = Filter.find_or_create_by!(
      free_drink: free_drink,
      free_food: free_food,
      private_room: private_room,
      course: course,
      midnight: midnight,
      non_smoking: non_smoking
    )
    # KeywordsとFiltersの組み合わせが存在しなかったら作成
    KeywordFilter.find_or_create_by!(keyword_id: keyword.id, filter_id: @filter.id)
    # ShopsとFiltersの組み合わせが存在しなかったら作成
    ShopFilter.find_or_create_by!(shop_id: shop.id, filter_id: @filter.id)
    # ShopsとKeywordsの組み合わせが存在しなかったら作成
    ShopKeyword.find_or_create_by!(shop_id: shop.id, keyword_id: keyword.id)
    end
  end
end
