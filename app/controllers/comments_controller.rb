class CommentsController < ApplicationController
  def create
    shop = Shop.find(params[:shop_id])
    comment = shop.comments.new(comment_params)
    comment.user = current_user
    if comment.save
      flash[:notice] = "コメントが作成されました"
      redirect_to shop_path(shop)
    else
      flash[:alert] = comment.errors.full_messages
      redirect_to shop_path(shop)
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @shop = @comment.shop
  end

  def update
    @comment = Comment.find(params[:id])
    @shop = @comment.shop
    if @comment.update(comment_params)
      flash[:notice] = "コメントを編集しました"
      redirect_to shop_path(@shop)
    else
      flash[:alert] = @comment.errors.full_messages
      redirect_to edit_shop_comment_path(@shop)
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    shop = comment.shop
    if comment.delete
      flash[:notice] = "コメントを削除しました"
      redirect_to shop_path(shop)
    else
      flash[:alert] = comment.errors.full_messages
      redirect_to shop_path(shop)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :visit_day, :value)
  end
end
