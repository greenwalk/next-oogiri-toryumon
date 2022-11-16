class CreateBasinFields < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_fields do |t|

      t.timestamps
    end
  end
end
