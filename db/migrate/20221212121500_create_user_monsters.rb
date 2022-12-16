class CreateUserMonsters < ActiveRecord::Migration[6.0]
  def change
    create_table :user_monsters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :monster, null: false, foreign_key: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
