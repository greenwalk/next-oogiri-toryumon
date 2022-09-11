class Admin::AdminsController < ApplicationController
  before_action :only_admin_user

  def top
    @field = Field.new
  end

  private
  def only_admin_user
    redirect_to root_path unless current_user&.admin_user?
  end
end
