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
    @shop = Shop.find(params[:shop_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @shop = @comment.shop
    if @comment.update(comment_params)
      flash[:notice] = "コメントを編集しました"
      redirect_to shop_path(@shop)
    else
      flash.now[:alert] = @comment.errors.full_messages
      render :edit
    end
  end

  def destroy
    shop = Shop.find(params[:shop_id])
    comment = Comment.find(params[:id])
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
    @comment = @shop.comments.new
    @comments = @shop.comments.includes(:user)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("value-frame", partial: "comments/create_form")
      end
      format.html { render "shops/show" }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :visit_day, :value)
  end
end
