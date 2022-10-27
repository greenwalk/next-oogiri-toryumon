class CommentLikesController < ApplicationController
  before_action :set_comment
  
  def create
      like = current_user.comment_likes.new(comment_id: @comment.id)
      like.save
      respond_to do |format|
        format.js{ render 'comment_likes/destroy.js.erb' }
      end
  end

  def destroy
    @like = CommentLike.find_by(user_id: current_user.id, comment_id: @comment.id).destroy
    respond_to do |format|
      format.js{ render 'comment_likes/create.js.erb' }
    end
  end

  private
  def set_comment
    @comment = Comment.find(params[:comment_id])
  end
end
