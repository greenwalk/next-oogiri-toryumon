class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_field
  before_action :set_oogiris, only: [:new, :thanks]
  before_action :dont_vote, only: [:new, :thanks]

  def new
    session[:ids] = @oogiris.pluck(:id)
    @form = Form::VoteCollection.new(current_user, @oogiris, @field, {})
    @votes = Vote&.where(field_id: @field.id)&.select(:user_id).distinct
  end

  def create
    # newでランダムに並び替えた@oogirisをその順番のまま取得する
    ids = session[:ids]
    @oogiris = Oogiri.where(id: ids).order("FIELD(id, #{ids.join(',')})")
    # 投票がなかったらエラー
    if params[:form_vote_collection].nil?
      @form = Form::VoteCollection.new(current_user, @oogiris, @field, {})
      @form.errors.add("全ての", "回答に投票してください")
      render :new and return
    end
    @form = Form::VoteCollection.new(current_user, @oogiris, @field, vote_collection_params)
    # 全部投票してなかったらエラー
    unless @form.votes.first.vote_point
      render :new and return
    end
    if already_voted?(@field)
      @form.errors.add("既に", "投票済みです")
      render :new and return
    end
    if @form.save
      redirect_to field_vote_thanks_path(@field.id)
    else
      render :new
    end
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
    @oogiris = @field.oogiris.shuffle
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
end