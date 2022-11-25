class CreateToryuSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :toryu_settings do |t|
      t.integer :point, null: false, default: 0
      t.integer :rank, null: false, default: 0

      t.timestamps
    end
  end
end
