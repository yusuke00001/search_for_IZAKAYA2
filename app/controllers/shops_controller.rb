class ShopsController < ApplicationController
  def index
    keyword = params[:keyword] || "名古屋市"
    @shops = HotpepperApi.search_shops(keyword)
    @shops = Kaminari.paginate_array(@shops).page(params[:page]).per(Shop.page_number)
  end
end
