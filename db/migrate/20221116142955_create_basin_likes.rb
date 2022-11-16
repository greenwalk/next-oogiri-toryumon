class CreateBasinLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_likes do |t|

      t.timestamps
    end
  end
end
