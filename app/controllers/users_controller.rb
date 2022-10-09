class UsersController < ApplicationController
  def show
    @users = User.order(rate: :desc)
    @user = User.includes(:oogiris, :votes, :comments).find(params[:id])
    @user_rank = @users.index(@user) + 1
    @fields = Field.group("DATE_FORMAT(created_at,'%Y-%m-%d')").status_finished
    @fields_num = @fields.length
    @oogiris = Oogiri.includes(:field).where(fields: {status: "finished"}).order(created_at: :desc)
    @user_oogiris = @oogiris.where(user_id: @user.id)
    @votes = Vote.group(:user_id, :field_id)
    @user_comments = Comment.includes(oogiri: :field).where(user_id: @user.id).order(created_at: :desc)
    @user_votes_num = @votes.where(user_id: @user.id).length
    @first_oogiris = Oogiri.includes(:field).where(get_rank: 1, user_id: @user.id)
    @minus_oogiris = Oogiri.includes(:field).where(point: -10000...0, user_id: @user.id)
  end
end