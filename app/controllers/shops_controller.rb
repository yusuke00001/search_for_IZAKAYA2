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
    @shops = HotpepperApi.search_shops(keyword, free_drink, free_food, private_room, course, midnight, non_smoking, sake, wine, cocktail, shochu)
    @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(Shop.page_number)
  end
end
