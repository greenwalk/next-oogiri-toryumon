class AddRateClassColumnToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :rate_class, :string, null: false, default: "<i class='fa-solid fa-seedling' style='color: #66CC00;'></i>", after: :max_rate
  end
  def down
    remove_column :users, :rate_class
  end
end