class AddChangeNumToVotes < ActiveRecord::Migration[6.0]
  def up
    add_column :votes, :change_num, :integer, null: false, default: 0
  end
  def down
    remove_column :votes, :change_num
  end
end