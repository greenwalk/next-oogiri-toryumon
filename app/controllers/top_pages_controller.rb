class TopPagesController < ApplicationController
  def top_page
  end

  def ranking
    @users = User.order(rate: :desc)
  end

  def privacy_policy
  end
end
