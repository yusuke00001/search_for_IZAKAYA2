class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインに成功しました"
    homes_path
  end

  def after_sign_out_path_for(resource)
    flash[:notice] = "ログアウトしました"
    user_session_path
  end
end
