class BasinLike < ApplicationRecord
  belongs_to :oogiri
  belongs_to :user

  validates_uniqueness_of :oogiri_id, scope: :user_id
end