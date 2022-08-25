class Admin::AdminsController < ApplicationController
  def top
    @field = Field.new
  end
end
