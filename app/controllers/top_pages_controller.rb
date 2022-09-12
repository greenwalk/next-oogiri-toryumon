class TopPagesController < ApplicationController
  def top_page
  end

  def ranking
    @users = User.order(rate: :desc)
  end
end
