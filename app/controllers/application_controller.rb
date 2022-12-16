class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :field_status_check
  before_action :set_now_field
  before_action :set_participating_limit

  add_flash_types :success, :info, :warning, :danger

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :oogiri_start])
  end
  def set_now_field
    @voting_fields = Field.status_voting
    @posting_fields = Field.status_posting
    @finished_fields = Field.status_finished.order(updated_at: :desc).limit(2)
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

  def redirect_to_newest_basin_field_page
    field = BasinField.order(updated_at: :desc).first
    if field.status_posting?
      redirect_to new_basin_field_basin_oogiri_path(field)
    elsif field.status_voting?
      redirect_to basin_field_basin_votes_path(field)
    elsif field.status_finished?
      redirect_to basin_field_basin_oogiris_path(field)
    end
  end
end
