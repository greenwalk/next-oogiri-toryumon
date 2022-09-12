class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_oogiri, only: [:create, :destroy]
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to field_oogiri_path(@oogiri.field, @oogiri)
    else
      render :oogiris/show
    end
  end

  def destroy
    @comment = @oogiri.comments.find(params[:id])
    @comment.destroy
    redirect_to field_oogiri_path(@oogiri.field, @oogiri)
  end

  private
  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, oogiri_id: @oogiri.id)
  end

  def set_oogiri
    @oogiri = Oogiri.find(params[:oogiri_id])
  end
end
