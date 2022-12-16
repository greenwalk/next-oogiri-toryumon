class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  has_many :oogiris
  has_many :votes
  has_many :comments
  has_many :comment_likes
  has_many :basin_oogiris
  has_many :basin_likes
  has_many :user_monsters
  has_many :monsters, through: :user_monsters

  validates :name, presence: true
  validates :oogiri_start, presence: true

  def admin_user?
    id == 4 || id == 459
  end

  def already_liked?(comment)
    self.comment_likes.exists?(comment_id: comment.id)
  end

  def already_basin_liked?(oogiri)
    self.basin_likes.exists?(basin_oogiri_id: oogiri.id)
  end
end
