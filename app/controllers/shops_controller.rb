class ShopsController < ApplicationController
  def index
    keyword= Keyword.find_by(word: params[:keyword])
    if keyword.present?
      filter(keyword)
    else
      word = params[:keyword]
      @shops = HotpepperApi.search_shops(**search_params)
      shops_create
      filter(word)
    end
    @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(Shop::PAGE_NUMBER)
  end

  def detail
    @shop = Shop.find_by(unique_number: params[:id])
    unless @shop
      shops_create
    end
  end

  private

  def search_params
    params.permit(:keyword)
          .to_h # ハッシュ化
          .symbolize_keys # キーを文字列からキーに変更
          .merge(keyword: params[:keyword].presence || "居酒屋")
  end

  def shops_create(word)
    keyword = Keyword.create(word: word)
    @shops.each do |shop_data|
      next if Shop.exists?(unique_number: shop_data["id"])

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
    ShopKeyword.create!(shop_id: shop.id, keyword_id: keyword.id)
    end
  end

  def filter(keyword)
    @shops = keyword.shops.where("free_drink LIKE ? AND free_food LIKE ? AND private_room LIKE ? AND course LIKE ? AND midnight LIKE ? AND non_smoking LIKE ?",
                                   "%#{params[:free_drink]}%", "%#{params[:free_food]}%", "%#{params[:private_room]}%", "%#{params[:course]}%", "%#{params[:midnight]}%", "%#{params[:non_smoking]}%")
  end
end
