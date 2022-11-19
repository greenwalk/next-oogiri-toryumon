class CreateBasinFields < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_fields do |t|
      t.integer :status, default: 0, comment: "お題ステータス"

      t.timestamps
    end
  end
end
