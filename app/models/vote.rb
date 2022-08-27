class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :oogiri

  validates_uniqueness_of :oogiri_id, scope: :user_id
end
