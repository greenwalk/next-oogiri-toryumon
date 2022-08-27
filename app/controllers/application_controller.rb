class ApplicationController < ActionController::Base
  before_action :set_now_field
  def set_now_field
    @now_field = Field.where(status: "posting").last
  end
end
