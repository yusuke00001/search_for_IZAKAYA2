class CommentsController < ApplicationController
  def create
    shop = Shop.find(params[:shop_id])
    comment = shop.comments.new(comment_params)
    comment.user = current_user
    if comment.save
      flash[:notice] = "コメントが作成されました"
      redirect_to shop_path(shop)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
