class BasinLikesController < ApplicationController
  before_action :set_oogiri

  def create
    like = current_user.basin_likes.new(basin_oogiri_id: @oogiri.id, basin_field_id: @oogiri.basin_field.id)
    like.save
    respond_to do |format|
      format.js{ render 'basin_likes/destroy.js.erb' }
    end
  end

  def destroy
    @like = BasinLike.find_by(user_id: current_user.id, basin_oogiri_id: @oogiri.id).destroy
    respond_to do |format|
      format.js{ render 'basin_likes/create.js.erb' }
    end
  end

  private
  def set_oogiri
    @oogiri = BasinOogiri.find(params[:basin_oogiri_id])
  end
end
