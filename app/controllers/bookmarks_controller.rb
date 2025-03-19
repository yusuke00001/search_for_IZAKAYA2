class BookmarksController < ApplicationController
  def index
    shops = Shop.joins(:bookmarks).where(bookmarks: { user_id: current_user.id })
    # ページネーション
    @current_page = (params[:page].to_i > 0) ? params[:page].to_i : 1
    @total_shops = shops.count
    @total_page = (@total_shops.to_f / Bookmark::PAGE_NUMBER).ceil
    @shops = shops.offset((@current_page - 1) * Bookmark::PAGE_NUMBER).limit(Bookmark::PAGE_NUMBER)

    # これ以上検索結果がない場合
    if @shops.empty? && @current_page > 1
      @current_page = @total_page
      @shops = shops.offset((@current_page - 1) * Bookmark::PAGE_NUMBER).limit(Bookmark::PAGE_NUMBER)
      flash[:alert] = "検索結果はこれ以上ありません"
    end

    @previous_page = @current_page > 1 ? @current_page - 1 : nil
    @next_page = @total_page > @current_page ? @current_page + 1 : nil
    @first_page = @current_page > 1 ?  1 : nil
    @last_page = @total_page > @current_page ? @total_page : nil
    @start_page = [ @current_page - Bookmark::DISPLAY_PAGE_RUNGE, 1 ].max
    @final_page = [ @current_page + Bookmark::DISPLAY_PAGE_RUNGE, @total_page ].min
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
