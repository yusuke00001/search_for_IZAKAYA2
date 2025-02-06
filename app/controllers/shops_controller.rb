class ShopsController < ApplicationController
  require "open-uri"
  def index
    keyword = params[:keyword] || "名古屋市"
    @shops = HotpepperAPI.search_shops(keyword)
  end
end
