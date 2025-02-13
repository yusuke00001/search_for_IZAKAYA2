class ShopsController < ApplicationController
  def index
    @shops = HotpepperApi.search_shops(**search_params)
    @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(Shop::PAGE_NUMBER)
  end

  def detail
    @shop = Shop.find_by(unique_number: params[:id])
    unless @shop
       @shop = Shop.create(
        unique_number: params[:id],
        name_of_shop: params[:name],
        address: params[:address],
        phone_number: params[:tel],
        access: params[:access],
        opening_hours: params[:open],
        closing_day: params[:close],
        budget: params[:budget],
        number_of_seats: params[:capacity],
        url: params[:urls],
        logo_image: params[:logo_image],
        image: params[:photo]
      )
    end
  end

  private

  def search_params
    params.permit(:keyword, :free_drink, :free_food, :private_room, :course,
                  :midnight, :non_smoking, :sake, :wine, :cocktail, :shochu)
          .to_h # ハッシュ化
          .symbolize_keys # キーを文字列からキーに変更
          .merge(keyword: params[:keyword].presence || "名古屋") # デフォルト値を設定
  end
end
