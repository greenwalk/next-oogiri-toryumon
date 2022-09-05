class Oogiri < ApplicationRecord
  belongs_to :user
  belongs_to :field

  has_many :votes

  validates :content, presence: true, length: { maximum: 200 }
end
