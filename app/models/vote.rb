class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :oogiri
  belongs_to :field

  validates :vote_point, presence: true
  validates :user_id, presence: true
  validates :oogiri_id, presence: true
  validates :field_id, presence: true
  validates_uniqueness_of :oogiri_id, scope: :user_id
end
