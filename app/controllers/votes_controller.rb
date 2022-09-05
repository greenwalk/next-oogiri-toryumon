class VotesController < ApplicationController
  before_action :set_oogiris, only: [:new, :create, :thanks]
  def new
    @form = Form::VoteCollection.new(current_user, @oogiris, @now_field, {})
  end

  def create
    @form = Form::VoteCollection.new(current_user, @oogiris, @now_field, vote_collection_params)
    if @form.save
      redirect_to vote_thanks_path, notice: "商品を登録しました"
    else
      flash.now[:alert] = "商品登録に失敗しました"
      render :new
    end
  end

  def thanks
    @votes = Vote.where(user_id: current_user.id)
  end

  private
  def vote_collection_params
    params.require(:form_vote_collection)
          .permit(votes_attributes: [:vote_point])
  end

  def set_oogiris
    @oogiris = @now_field.oogiris
  end
end