class Monster < ApplicationRecord
  enum status: {unused: 0, used: 1 }, _prefix: true
  enum species: {dragon: 0, human: 1, fish: 2, beast: 4, others: 5}, _prefix: true
end
