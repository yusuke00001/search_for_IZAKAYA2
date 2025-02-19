class ShopsController < ApplicationController
  def index
    params[:keyword] = "居酒屋" if params[:keyword].blank?
    if params[:start]
      params[:start] = params[:start].to_i * 10 + 1
    else
      params[:start] = 1
    end
    @keyword= Keyword.find_by(word: params[:keyword])
    unless @keyword.present? && params[:start] == 1
      @API_shop_data = HotpepperApi.search_shops(**search_params)
      word = params[:keyword]
      @keyword = Keyword.create!(word: word) unless Keyword.find_by(word: word)
      shops_create(@keyword)
    end
    @shops = @keyword.shops
    @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(Shop::PAGE_NUMBER)
  end

  private

  def search_params
    params.permit(:keyword, :start)
          .to_h # ハッシュ化
          .symbolize_keys # キーを文字列からキーに変更
          .merge(keyword: params[:keyword])
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
          image: shop_data["photo"],
          free_drink: shop_data["free_drink"],
          free_food: shop_data["free_food"],
          private_room: shop_data["private_room"],
          course: shop_data["course"],
          midnight: shop_data["midnight"],
          non_smoking: shop_data["non_smoking"],
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
        image: shop_data["photo"],
        free_drink: shop_data["free_drink"],
        free_food: shop_data["free_food"],
        private_room: shop_data["private_room"],
        course: shop_data["course"],
        midnight: shop_data["midnight"],
        non_smoking: shop_data["non_smoking"],
    )
      end
    ShopKeyword.find_or_create_by!(shop_id: shop.id, keyword_id: keyword.id)
    end
  end
end
