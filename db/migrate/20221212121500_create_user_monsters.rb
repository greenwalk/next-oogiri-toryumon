class CreateUserMonsters < ActiveRecord::Migration[6.0]
  def change
    create_table :user_monsters do |t|

      t.timestamps
    end
  end
end
