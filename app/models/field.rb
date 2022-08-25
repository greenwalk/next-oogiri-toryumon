class Field < ApplicationRecord
  validates :status, presence: true
  validates :text_theme, presence: true

  enum status: { posting: 0, voting: 1, finished: 2 }
end
