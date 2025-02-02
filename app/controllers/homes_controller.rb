class HomesController < ApplicationController
  def index
    @user = current_user
  end

  def create
    @user = current_user
    @user.avatar.attach(params[:user][:avatar])
  end
end
