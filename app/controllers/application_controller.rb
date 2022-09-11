class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_now_field

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :oogiri_start])
  end
  def set_now_field
    @now_field = Field.order(created_at: :desc).first
  end
end
