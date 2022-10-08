class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :field_status_check
  before_action :set_now_field

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :oogiri_start])
  end
  def set_now_field
    @now_fields = if @field_status == "投稿"
                    Field.status_posting
                  elsif @field_status == "投票"
                    Field.status_voting
                  else
                    Field.status_finished.order(created_at: :desc).limit(2)
                  end
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
end
