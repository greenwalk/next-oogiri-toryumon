class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  has_many :oogiris
  has_many :votes
  has_many :comments
  has_many :comment_likes

  validates :name, presence: true
  validates :oogiri_start, presence: true

  def admin_user?
    id == 4 || id == 459
  end

  def already_liked?(comment)
    self.comment_likes.exists?(comment_id: comment.id)
  end
end
