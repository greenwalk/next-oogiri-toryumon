class AddColumnThemeToFields < ActiveRecord::Migration[6.0]
  def up
    add_column :basin_fields, :theme, :string, default: "", null: false, after: :id
  end
  def down
    remove_column :basin_fields, :theme
  end
end
