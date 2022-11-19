class AddColumnsRankAndPointToBasinOogiris < ActiveRecord::Migration[6.0]
  def up
    add_column :basin_oogiris, :point, :integer, default: 0, null: false, after: :content
    add_column :basin_oogiris, :rank, :integer, default: 0, null: false, after: :point
  end
  def down
    remove_column :basin_oogiris, :point
    remove_column :basin_oogiris, :rank
  end
end
