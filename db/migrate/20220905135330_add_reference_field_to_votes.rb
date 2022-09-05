class AddReferenceFieldToVotes < ActiveRecord::Migration[6.0]
  def up
    add_reference :votes, :field, null: false
  end
  def down
    remove_reference :votes, :field
  end
end
