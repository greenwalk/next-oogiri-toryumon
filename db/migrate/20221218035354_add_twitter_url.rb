class AddTwitterUrl < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :twitter_url, :string, default: "", null: false
  end
  def down
    remove_column :users, :twitter_url
  end
end
