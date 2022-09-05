class VotesController < ApplicationController
  before_action :set_oogiris, only: [:new, :create]
  def new
    @form = Form::VoteCollection.new(current_user, @oogiris, {})
  end

  def create
    @form = Form::VoteCollection.new(current_user, @oogiris, vote_collection_params)
    if @form.save
      redirect_to vote_thanks_path, notice: "商品を登録しました"
    else
      flash.now[:alert] = "商品登録に失敗しました"
      render :new
    end
  end

  def thanks
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