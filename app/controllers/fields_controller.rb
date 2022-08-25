class FieldsController < ApplicationController
  def index
    @field = Field.where(status: "posting").last
  end

  def create
    @field = Field.new(field_params)
    if @field.save
      redirect_to fields_path
    else
      render "admin/admins/top"
    end
  end

  private
  def field_params
    params.require(:field).permit(:text_theme, :status)
  end
end
