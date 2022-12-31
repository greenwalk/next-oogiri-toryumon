class ChangeNullTwitterUrlToUsers < ActiveRecord::Migration[6.0]
  def up
    change_column_null :users, :twitter_url, true
  end

  def down
    change_column_null :users, :twitter_url, false
  end
end
