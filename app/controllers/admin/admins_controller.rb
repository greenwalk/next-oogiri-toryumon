class Admin::AdminsController < ApplicationController
  before_action :only_admin_user

  def top
    # お題作成用
    @field = Field.new
    # 現在のお題
    @two_fields = Field.order(updated_at: :desc).limit(2)
    # 過去のお題用
    @first_oogiris = Oogiri.includes(:field).where(get_rank: 1)
    @minus_oogiris = Oogiri.includes(:field).where(point: -10000...0)
    # ユーザー一覧用
    @users = User.order(created_at: :asc)
  end

  private
  def only_admin_user
    redirect_to root_path unless current_user&.admin_user?
  end
end
