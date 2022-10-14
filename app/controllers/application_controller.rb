class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :field_status_check
  before_action :set_now_field
  before_action :set_participating_limit

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :oogiri_start])
  end
  def set_now_field
    @voting_fields = Field.status_voting
    @posting_fields = Field.status_posting
    @finished_fields = Field.status_finished.order(created_at: :desc).limit(2)
  end

  def field_status_check
    if Field.status_posting.present?
      @field_status = "投稿"
    elsif Field.status_voting.present?
      @field_status = "投票"
    else
      @field_status = "結果"
    end
  end

  def set_participating_limit
    @limit_num = 25
  end
end
