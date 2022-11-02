class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_field
  before_action :set_oogiris, only: [:new, :create, :thanks]
  before_action :dont_vote, only: [:new, :thanks]
  helper_method :already_voted?
  helper_method :cant_chage_votes

  def new
    @form = Form::VoteCollection.new(current_user, @oogiris, @field, {})
    @votes = Vote&.where(field_id: @field.id)&.select(:user_id).distinct
  end

  def create
    params[:form_vote_collection][:votes_attributes].each do |vote|
      @vote = Vote.find_or_create_by(user_id: current_user.id, oogiri_id: vote[1][:oogiri_id].to_i, field_id: @field.id)
      @vote.update_attributes({vote_point: vote[1][:vote_point].to_i, change_num: @vote.change_num + 1})
    end
    redirect_to field_vote_thanks_path(@field.id)
  end

  def thanks
    unless already_voted?(@field)
      redirect_to new_field_vote_path(@field.id)
    end
    @votes = Vote.where(user_id: current_user.id, field_id: @field.id)
  end

  private
  def vote_collection_params
    params.require(:form_vote_collection).permit(votes_attributes: [:vote_point])
  end

  def set_oogiris
    @oogiris = @field.oogiris
  end

  def set_field
    @field = Field.find(params[:field_id])
  end

  def dont_vote
    redirect_to root_path unless @field.status_voting?
  end

  def already_voted?(field)
    field.votes.pluck(:user_id).include?(current_user&.id)
  end

  def cant_chage_votes
    Vote.where(user_id: current_user.id, field_id: @field.id, change_num: 2..10).present?
  end
end