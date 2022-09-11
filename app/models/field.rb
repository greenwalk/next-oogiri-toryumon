class Field < ApplicationRecord
  has_many :oogiris
  has_many :votes

  validates :status, presence: true
  validates :text_theme, presence: true

  enum status: { posting: 0, voting: 1, finished: 2 }, _prefix: true
end
