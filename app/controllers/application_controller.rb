class ApplicationController < ActionController::Base
  before_action :set_now_field
  def set_now_field
    @now_field = Field.order(created_at: :desc).first
  end
end
