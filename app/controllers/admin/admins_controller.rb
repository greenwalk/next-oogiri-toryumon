class Admin::AdminsController < ApplicationController
  before_action :only_admin_user

  def top
    # お題作成用
    @field = Field.new
    # 過去のお題用
    @fields_finished = Field.where(status: "finished")
    # ユーザー一覧用
    @users = User.order(created_at: :asc)
  end

  private
  def only_admin_user
    redirect_to root_path unless current_user&.admin_user?
  end
end
