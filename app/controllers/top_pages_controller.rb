class TopPagesController < ApplicationController
  def top_page
  end

  def ranking
    @users = User.eager_load(:oogiris).where.not(oogiris: {id: nil}).order(rate: :desc)
  end

  def privacy_policy
  end
end
