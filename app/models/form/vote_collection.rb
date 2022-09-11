class Form::VoteCollection < Form::Base
  attr_accessor :user, :oogiris, :field
  attr_accessor :votes

  validates :user, presence: true
  validates :oogiris, presence: true
  validates :field, presence: true
  validates :votes, presence: true

  def initialize(user, oogiris, field, attributes = {})
    @user = user
    @oogiris = oogiris
    @field = field
    super attributes
    self.votes = @oogiris.map{|oogiri| Vote.new(vote_point: nil, user_id: user.id, oogiri_id: oogiri.id, field_id: field.id)} unless self.votes.present?
  end

  # 上でsuper attributesとしているので必要
  def votes_attributes=(attributes)
    begin
      self.votes = @oogiris.zip(attributes.values).map { |o, v| Vote.new(user_id: user.id, oogiri_id: o.id, field_id: field.id, vote_point: v[:vote_point]) }
    rescue
      errors.add("全ての", '回答に投票してください')
      return @form = false
    end
  end

  def save
    return if invalid?

    Vote.transaction do
      return false unless self.votes.map(&:save)
    end
    return true
  rescue => e
    return false
  end
end