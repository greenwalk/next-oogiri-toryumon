class BasinField < ApplicationRecord
  has_many :basin_oogiris
  has_many :basin_likes

  validates :status, presence: true
  validates :theme, presence: true

  enum status: { posting: 0, voting: 1, finished: 2}, _prefix: true
end