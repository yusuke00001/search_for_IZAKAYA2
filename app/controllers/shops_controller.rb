class ShopsController < ApplicationController
  def index
    keyword= Keyword.find_by(word: params[:keyword])
    if keyword.present?
      @shops = keyword.shops.where(free_drink: params[:free_drink], free_food: params[:free_food], private_room: params[:private_room], course: params[:course], midnight: params[:midnight],
                                   non_smoking: params[:non_smoking], wine: params[:wine], sake: params[:sake], cocktail: params[:cocktail], shochu: params[:shochu])
    else
      @word = params[:keyword]
      @filter = params.permit(:free_drink, :free_food, :private_room, :course,
                              :midnight, :non_smoking, :sake, :wine, :cocktail, :shochu)
      @shops = HotpepperApi.search_shops(**search_params)
      shops_create
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
    params.permit(:keyword, :free_drink, :free_food, :private_room, :course,
                  :midnight, :non_smoking, :sake, :wine, :cocktail, :shochu)
          .to_h # ハッシュ化
          .symbolize_keys # キーを文字列からキーに変更
          .merge(keyword: params[:keyword].presence || "名古屋",
          free_drink: "0",
          free_food: "0",
          private_room: "0",
          course: "0",
          midnight: "0",
          non_smoking: "0",
          sake: "0",
          wine: "0",
          cocktail: "0",
          shochu: "0") # デフォルト値を設定
  end

  def shops_create
    keyword = Keyword.create(word: @word)
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
        free_drink: @filter[:free_drink],
        free_food: @filter[:free_food],
        private_room: @filter[:private_room],
        course: @filter[:course],
        midnight: @filter[:midnight],
        non_smoking: @filter[:non_smoking],
        sake: @filter[:sake],
        wine: @filter[:wine],
        cocktail: @filter[:cocktail],
        shochu: @filter[:shochu]
    )
    ShopKeyword.create!(shop_id: shop.id, keyword_id: keyword.id)
    end
  end
end
