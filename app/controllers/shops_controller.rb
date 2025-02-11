class ShopsController < ApplicationController
  def index
    keyword = params[:keyword].presence || "居酒屋"
    free_drink = params[:free_drink]
    free_food = params[:free_food]
    private_room = params[:praivate_room]
    course = params[:course]
    midnight = params[:midnight]
    non_smoking = params[:wine]
    sake = params[:sake]
    wine = params[:wine]
    cocktail = params[:cocktail]
    shochu = params[:shochu]
    @shops = HotpepperApi.search_shops_gourmet(keyword, free_drink, free_food, private_room, course, midnight, non_smoking, sake, wine, cocktail, shochu)
    @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(Shop.page_number)
  end

  def detail
    unless Shop.find_by(unique_number: params[:id])
       Shop.create(
        unique_number: params[:id],
        name_of_shop: params[:name],
        address: params[:address],
        phone_number: params[:tel],
        access: params[:access],
        opening_hours: params[:open],
        closing_day: params[:close],
        budget: params[:budget]
      )
    end
  end
end
