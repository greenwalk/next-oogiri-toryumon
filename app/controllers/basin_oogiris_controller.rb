class BasinOogirisController < ApplicationController
  before_action :authenticate_user!
  before_action :set_field
  before_action :set_oogiri, only: [:destroy]
  before_action :dont_look_result, only: [:index]
  before_action :dont_create_oogiri, only: [:new]
  before_action :dont_vote, only: [:vote]

  def index
    @oogiris = @field.basin_oogiris.includes(:basin_likes).order(rank: :asc)
  end

  def new
    @view_oogiri = BasinOogiri.find_by(user_id: current_user.id, basin_field_id: @field.id) || BasinOogiri.new
    @oogiri = BasinOogiri.new
  end

  def create
    @oogiri = BasinOogiri.find_or_initialize_by(user_id: current_user.id, basin_field_id: @field.id)
    if @oogiri.update_attributes(oogiri_params)
      redirect_to new_basin_field_basin_oogiri_path(basin_field_id: @field.id)
    else
      @view_oogiri = BasinOogiri.find_by(user_id: current_user.id, basin_field_id: @field.id) || BasinOogiri.new
      render :new
    end
  end

  def destroy
    @oogiri.destroy
    redirect_to new_basin_field_basin_oogiri_path(basin_field_id: @field.id)
  end

  def vote
    @oogiris = @field.basin_oogiris.shuffle
  end

  private
  def oogiri_params
    params.require(:basin_oogiri).permit(:content, :point, :rank).merge(user_id: current_user.id, basin_field_id: @field.id)
  end

  def set_oogiri
    @oogiri = BasinOogiri.find(params[:id])
  end

  def set_newest_field
    @n_field = BasinField.order(updated_at: :desc).first
  end

  def set_field
    @field = BasinField.find(params[:basin_field_id])
  end

  def dont_look_result
    redirect_to_newest_basin_field_page unless @field.status_finished?
  end

  def dont_create_oogiri
    redirect_to_newest_basin_field_page unless @field.status_posting?
  end

  def dont_vote
    redirect_to_newest_basin_field_page unless @field.status_voting?
  end
end