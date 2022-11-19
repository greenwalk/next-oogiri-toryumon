class BasinFieldsController < ApplicationController
  before_action :redirect_to_newest_basin_field_page, only: [:now_basin_field]
  def now_basin_field
  end
end