class AddNameToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :name, :string, null: false, default: ""
  end
end
