class BasinOogiri < ApplicationRecord
  belongs_to :user
  belongs_to :basin_field

  has_many :basin_likes

  validates :content, presence: true, length: { maximum: 30 }
end