class BookmarksController < ApplicationController
  def index
    @bookmark_shops = Shop.joins(:bookmarks).where(bookmarks: { user_id: current_user.id })
    @current_page = (params[:page].to_i > 0) ? params[:page].to_i : 1
    @total_shops = @bookmark_shops.count
    @total_page = (@total_shops.to_f / Shop::PAGE_NUMBER).ceil
    @bookmark_shops = @bookmark_shops.offset((@current_page - 1)* Shop::PAGE_NUMBER).limit(Shop::PAGE_NUMBER)
    @previous_page = @current_page > 1 ? @current_page - 1 : nil
    @next_page = @total_page > @current_page ? @current_page + 1 : nil
    @first_page = @current_page > 1 ? 1 : nil
    @last_page = @total_page > 1 ? @total_page : nil
    @start_page = [ @current_page - 3, 1 ].max
    @final_page = [ @current_page + 3, @total_page ].min
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
