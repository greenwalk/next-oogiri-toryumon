class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :oogiris
  has_many :votes
  has_many :comments

  validates :name, presence: true
  validates :oogiri_start, presence: true

  def admin_user?
    id == 1
  end
end
