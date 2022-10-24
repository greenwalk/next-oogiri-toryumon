class Field < ApplicationRecord
  has_many :oogiris
  has_many :votes

  validates :status, presence: true
  validates :text_theme, presence: true

  enum status: { posting: 0, voting: 1, finished: 2, permitted: 3, waiting: 4 }, _prefix: true
end
