class Form::VoteCollection < Form::Base
  attr_accessor :user, :oogiris
  attr_accessor :votes

  def initialize(user, oogiris, attributes = {})
    @user = user
    @oogiris = oogiris
    super attributes
    self.votes = @oogiris.map{|oogiri| Vote.new(vote_point: nil, user_id: user.id, oogiri_id: oogiri.id)} unless self.votes.present?
  end

  # 上でsuper attributesとしているので必要
  def votes_attributes=(attributes)
    self.votes = attributes.values.zip(@oogiris).map { |v, o| Vote.new(user_id: user.id, oogiri_id: o.id, vote_point: v[:vote_point]) }
  end

  def save
    Vote.transaction do
      self.votes.map(&:save!)
    end
    return true
  rescue => e
    return false
  end
end