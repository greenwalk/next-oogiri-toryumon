class FieldsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :set_field, only: [:update]
  def index
    @fields = Field.where(status: "finished")
  end

  def create
    @field = Field.new(field_params)
    if @field.save
      redirect_to fields_path
    else
      render "admin/admins/top"
    end
  end

  def update
    if @field.status_posting?
      next_status = "voting"
    elsif @field.status_voting?
      next_status = "finished"
    else
      next_status = "posting"
    end
    if @field.update(status: next_status)
      redirect_to admin_top_path
    else
      render "admin/admins/top"
    end
  end

  private
  def field_params
    params.require(:field).permit(:text_theme, :status)
  end

  def set_field
    @field = Field.find(params[:id])
  end
end
