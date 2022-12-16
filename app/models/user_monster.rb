class UserMonster < ApplicationRecord
  belongs_to :user
  belongs_to :monster

  enum status: {now: 0, past: 1}, _prefix: true
end
