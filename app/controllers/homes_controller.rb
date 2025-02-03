class HomesController < ApplicationController
  before_action :current_user?
  def index
  end

  def create
    current_user.avatar.attach(params[:user][:avatar])
  end

  def current_user?
    unless current_user.present?
      redirect_to user_session_path
      flash[:alert] = "ログインしてください"
    end
  end
end
