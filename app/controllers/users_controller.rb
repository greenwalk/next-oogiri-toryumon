class UsersController < ApplicationController
  def show
    # 対象のユーザーを取得
    @users = User.eager_load(:oogiris).where.not(oogiris: {id: nil}).order(rate: :desc)
    @user = User.includes(:oogiris, :votes, :comments).find(params[:id])
    # ユーザーのrate順位(=ランク)
    @user_rank = if @users.index(@user).present?
                   @users.index(@user) + 1
                 else
                   "-"
                 end
    # 終了したお題を日付ごとにグループ化して取得(分母に使用するため)
    @fields = Field.group("DATE_FORMAT(created_at,'%Y-%m-%d')").status_finished
    @fields_num = @fields.length
    # ユーザーの大喜利を取得
    @oogiris = Oogiri.includes(:field).where(fields: {status: "finished"}).order(created_at: :desc)
    @user_oogiris = @oogiris.where(user_id: @user.id)
    @first_oogiris = Oogiri.includes(:field).where(get_rank: 1, user_id: @user.id)
    @minus_oogiris = Oogiri.includes(:field).where(point: -10000...0, user_id: @user.id)
    # ユーザーの投票を取得
    @votes = Vote.group(:user_id, :field_id)
    @user_votes_num = @votes.where(user_id: @user.id).length
    # ユーザーのコメントを取得
    @user_comments = Comment.includes(oogiri: :field).where(user_id: @user.id).order(created_at: :desc)
    @received_comments = Comment.includes(oogiri: [:user, :field]).where(oogiris: {fields: {status: :finished}}).where.not(user_id: @user.id).where(oogiris: {user_id: @user.id}).order(created_at: :desc)
  end
end