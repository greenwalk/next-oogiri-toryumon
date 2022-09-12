class AddRateColumnsToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :rate, :integer, null: false, default: 1500, after: :name
    add_column :users, :max_rate, :integer, null: false, default: 1500, after: :rate
    add_column :users, :oogiri_start, :date, null: false, after: :max_rate
  end
  def down
    remove_column :users, :rate
    remove_column :users, :max_rate
    remove_column :users, :oogiri_start
  end
end
