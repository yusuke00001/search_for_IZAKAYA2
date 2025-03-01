class BookmarksController < ApplicationController
  def index
    shops = Shop.joins(:bookmarks).where(bookmarks: { user_id: current_user.id })
    pagination(shops)
  end
  def create
    bookmark = Bookmark.new(bookmark_params)
    if bookmark.save
      flash[:notice] = "お気に入り登録しました"
      redirect_back fallback_location: shops_path
    end
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    bookmark.destroy
    flash[:alert] = "お気に入りを解除しました"
    redirect_back fallback_location: shops_path
  end

  private

  def bookmark_params
    params.permit(:shop_id, :user_id)
  end
end
