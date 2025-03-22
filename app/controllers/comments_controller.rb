class CommentsController < ApplicationController
  def create
    binding.pry
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
    # valueは1から始まるが、UIでは0から始めるため、-1とする
    @value = @comment.value - 1
  end

  def update
    @comment = Comment.find(params[:id])
    @shop = @comment.shop
    if @comment.update(comment_params)
      flash[:notice] = "コメントを編集しました"
      redirect_to shop_path(@shop)
    else
      flash.now[:alert] = @comment.errors.full_messages
      render :edit, status: :unprocessable_entity
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

  def value
    @value = params[:value].to_i
    @shop = Shop.find(params[:shop_id])
    @comment = @shop.comments.find_by(id: params[:id]) || @shop.comments.new
    @comments = @shop.comments.includes(:user)

    render "shops/show"
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :visit_day, :value)
  end
end
