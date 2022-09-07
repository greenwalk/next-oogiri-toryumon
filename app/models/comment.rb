class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :oogiri

  validates :content, presence: true, length: { maximum: 200 }
end
