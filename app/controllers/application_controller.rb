class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :avatar ])
  end

  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインに成功しました"
    homes_path
  end

  def after_sign_out_path_for(resource)
    flash[:notice] = "ログアウトしました"
    user_session_path
  end

  PAGE_NUMBER = 10
  DISPLAY_PAGE_RANGE = 3

  def pagination(shops:, current_location_search: nil, shop_ids: nil, current_latitude: nil, current_longitude: nil)
    # @keywordがtrue→shopsコントローラからの処理 false→bookmarksコントローラからの処理
    if @keyword
      @keyword_filter_params = @filter_conditions.merge(keyword: @keyword.word, current_location: current_location_search, shop_ids: shop_ids, latitude: current_latitude, longitude: current_longitude)
    end
    @current_page = (params[:page].to_i > 0) ? params[:page].to_i : 1
    @total_shops = shops.count
    @total_page = (@total_shops.to_f / 10).ceil
    @shops = shops.offset((@current_page - 1) * PAGE_NUMBER).limit(PAGE_NUMBER)

    if @shops.empty? && @current_page > 1
      @current_page = @total_page
      @shops = shops.offset((@current_page - 1) * PAGE_NUMBER).limit(PAGE_NUMBER)
      flash[:alert] = "検索結果はこれ以上ありません"
    end

    @previous_page = @current_page > 1 ? @current_page - 1 : nil
    @next_page = @total_page > @current_page ? @current_page + 1 : nil
    @first_page = @current_page > 1 ?  1 : nil
    @last_page = @total_page > @current_page ? @total_page : nil
    @start_page = [ @current_page - DISPLAY_PAGE_RANGE, 1 ].max
    @final_page = [ @current_page + DISPLAY_PAGE_RANGE, @total_page ].min
  end
end
