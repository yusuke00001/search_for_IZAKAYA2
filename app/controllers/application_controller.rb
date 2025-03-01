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

  def pagination(shops)
    @current_page = (params[:page].to_i > 0) ? params[:page].to_i : 1
    @total_shops = shops.count
    @total_page = (@total_shops.to_f / 10).ceil
    @shops = shops.offset((@current_page - 1) * PAGE_NUMBER).limit(PAGE_NUMBER)
    @previous_page = @current_page > 1 ? @current_page - 1 : nil
    @next_page = @total_page > @current_page ? @current_page + 1 : nil
    @first_page = @current_page > 1 ?  1 : nil
    @last_page = @total_page > @current_page ? @total_page : nil
    @start_page = [ @current_page - 3, 1 ].max
    @final_page = [ @current_page + 3, @total_page ].min
  end
end
