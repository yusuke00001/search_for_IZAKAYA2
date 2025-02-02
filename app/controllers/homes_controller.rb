class HomesController < ApplicationController
  def index
  end

  def create
    current_user.avatar.attach(params[:user][:avatar])
  end
end
