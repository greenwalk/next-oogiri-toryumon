class AddReferenceFieldToBasinLikes < ActiveRecord::Migration[6.0]
  def up
    add_reference :basin_likes, :basin_field, null: false
  end
  def down
    remove_reference :basin_likes, :basin_field
  end
end
