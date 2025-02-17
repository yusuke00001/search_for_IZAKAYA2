class ShopsController < ApplicationController
  def index
    params[:keyword] = "居酒屋" if params[:keyword].blank?
    keyword= Keyword.find_by(word: params[:keyword])
    unless keyword.present?
      @API_shop_data = HotpepperApi.search_shops(**search_params)
      word = params[:keyword]
      keyword = Keyword.create!(word: word)
      shops_create(keyword)
    end
    @shops = keyword.shops.where("free_drink LIKE ? AND free_food LIKE ? AND private_room LIKE ? AND course LIKE ? AND midnight LIKE ? AND non_smoking LIKE ?",
                                   "%#{params[:free_drink].presence || ""}%", "%#{params[:free_food].presence || ""}%", "%#{params[:private_room].presence || ""}%", "%#{params[:course].presence || ""}%", "%#{params[:midnight].presence || ""}%", "%#{params[:non_smoking].presence || ""}%")
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
          .merge(keyword: params[:keyword])
  end

  def shops_create(keyword)
    @API_shop_data.each do |shop_data|
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
end
