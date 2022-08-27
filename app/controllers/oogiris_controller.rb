class OogirisController < ApplicationController
  before_action :set_oogiri, only: [:edit, :update, :destroy]
  before_action :set_field, only: [:new, :create, :edit, :update, :destroy]

  def new
    # 俳句を既に投稿している場合は、俳句編集ページへ移動。していない場合は、投稿ページへ移動
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

  def destroy
    @oogiri.destroy
    redirect_to new_field_oogiri_path(@field)
  end

  private
  def oogiri_params
    params.require(:oogiri).permit(:content, :point, :score, :get_rank).merge(user_id: current_user.id, field_id: @now_field.id)
  end

  def set_oogiri
    @oogiri = Oogiri.find(params[:id])
  end

  def set_field
    @field = Field.find(params[:field_id])
  end
end