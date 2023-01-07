class OogirisController < ApplicationController
  before_action :authenticate_user!, except: [:index, :vote_show]
  before_action :redirect_to_registration_twitter_page, except: [:index, :vote_show]
  before_action :set_field, only: [:index, :new, :create, :edit, :update, :show, :vote_show, :destroy]
  before_action :set_oogiri, only: [:edit, :update, :show, :vote_show, :destroy]
  before_action :dont_look_result, only: [:index, :vote_show]
  before_action :dont_create_oogiri,:check_oogiris_num, only: [:new, :edit]
  before_action :dont_look_oogiri, only: [:show]

  def index
    @oogiris = @field.oogiris.order(get_rank: :asc)
    @comments = Comment.all
    @votes = Vote&.where(field_id: @field.id)&.select(:user_id).distinct
  end

  def new
    # 大喜利を既に投稿している場合は、大喜利編集ページへ移動。していない場合は、投稿ページへ移動
    if Oogiri.exists?(user_id: current_user.id, field_id: @field.id)
      @oogiri = Oogiri.where(user: current_user, field: @field).last
      redirect_to edit_field_oogiri_path(field_id: @field.id, id: @oogiri.id)
    else
      @oogiri = Oogiri.new
    end
  end

  def create
    @oogiri = Oogiri.new(oogiri_params)
    if @oogiri.save
      redirect_to edit_field_oogiri_path(field_id: @field.id, id: @oogiri.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @oogiri.update(oogiri_params)
      redirect_to edit_field_oogiri_path(field_id: @field.id, id: @oogiri.id)
    else
      render :edit
    end
  end

  def show
    @comment = Comment.new
    @comments = Comment.where(oogiri_id: @oogiri.id, created_at: "1900-01-01"..@field.updated_at)
    @late_comments = Comment.where(oogiri_id: @oogiri.id, created_at: @field.updated_at...)
  end

  def vote_show

  end

  def destroy
    @oogiri.destroy
    redirect_to new_field_oogiri_path(@field)
  end

  private
  def oogiri_params
    params.require(:oogiri).permit(:content, :point, :score, :get_rank).merge(user_id: current_user.id, field_id: @field.id)
  end

  def set_oogiri
    @oogiri = Oogiri.find(params[:id])
  end

  def set_field
    @field = Field.find(params[:field_id])
  end

  def dont_look_result
    redirect_to root_path unless @field.status_finished?
  end

  def dont_create_oogiri
    redirect_to root_path unless @field.status_posting?
  end

  def check_oogiris_num
    redirect_to root_path if @field.oogiris.length >= @limit_num && @field.oogiris.where(user_id: current_user.id).empty?
  end

  def dont_look_oogiri
    redirect_to new_field_oogiri_path(@field) if @field.status_posting?
  end

  def redirect_to_registration_twitter_page
    redirect_to registration_twitter_user_path(current_user.id) unless current_user&.twitter_url&.present?
  end
end
