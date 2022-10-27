class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :oogiri
  has_many :comment_likes

  validates :content, presence: true, length: { maximum: 255 }
end
