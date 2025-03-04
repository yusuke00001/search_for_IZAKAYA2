class BookmarksController < ApplicationController
  def index
    shops = Shop.joins(:bookmarks).where(bookmarks: { user_id: current_user.id })
    pagination(shops)
  end
  def create
    bookmark = Bookmark.new(bookmark_params)
    if bookmark.save
      flash[:notice] = "お気に入り登録しました"
    else
      flash[:alert] = "お気に入り登録に失敗しました: #{ bookmark.errors.full_messages }"
    end
    redirect_back fallback_location: shops_path
  end

  def destroy
    bookmark = Bookmark.find(params[:id])
    if bookmark.destroy
      flash[:alert] = "お気に入りを解除しました"
    else
      flash[:alert] = "お気に入り登録の解除に失敗しました: #{bookmark.errors.full_messages }"
    end
    redirect_back fallback_location: shops_path
  end

  private

  def bookmark_params
    params.permit(:shop_id, :user_id)
  end
end
