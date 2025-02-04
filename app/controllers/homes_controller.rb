class HomesController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def create
    current_user.avatar.attach(params[:user][:avatar])
  end
end
