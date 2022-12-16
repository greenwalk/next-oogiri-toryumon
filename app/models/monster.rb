class Monster < ApplicationRecord
  has_many :user_monsters
  has_many :users, through: :user_monsters

  enum status: {unused: 0, used: 1 }, _prefix: true
  enum species: {dragon: 0, human: 1, fish: 2, beast: 3, others: 4}, _prefix: true
end
