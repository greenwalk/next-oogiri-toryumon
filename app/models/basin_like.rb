class BasinLike < ApplicationRecord
  belongs_to :basin_oogiri
  belongs_to :user

  validates_uniqueness_of :basin_oogiri_id, scope: :user_id
end