class CreateMonsters < ActiveRecord::Migration[6.0]
  def change
    create_table :monsters do |t|
      t.string :name, null: false
      t.integer :status, null: false, default: 0
      t.string :image, null: false, default: ""
      t.integer :level, null:false, default: 0
      t.integer :species, null:false

      t.timestamps
    end
  end
end
