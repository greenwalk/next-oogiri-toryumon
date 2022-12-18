class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_registration_twitter_page
  before_action :set_oogiri, only: [:create, :destroy]
  before_action :set_field, only: [:create, :destroy]

  def index
    @comments = Comment.includes(:user, oogiri: :field).where(oogiris: {fields: {status: :finished}}).order(created_at: :desc).page(params[:page]).per(20)
  end
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to field_oogiri_path(@oogiri.field, @oogiri)
    else
      @comments = Comment.where(oogiri_id: @oogiri.id)
      render "oogiris/show"
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

  def set_field
    @field = Field.find(params[:field_id])
  end

  def redirect_to_registration_twitter_page
    redirect_to registration_twitter_user_path(current_user.id) unless current_user&.twitter_url&.present?
  end
end
