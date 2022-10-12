class TopPagesController < ApplicationController
  def top_page
  end

  def ranking
    @users = User.eager_load(:oogiris).where.not(oogiris: {id: nil}).order(rate: :desc)
  end

  def privacy_policy
  end

  def minus_oogiris
    @minus_oogiris = Oogiri.includes(:field).where(point: -10000...0)
  end
end
