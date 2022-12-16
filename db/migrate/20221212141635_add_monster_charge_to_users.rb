class AddMonsterChargeToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :monster_charge, :integer, default: 0, null: false
  end
  def down
    remove_column :users, :monster_charge
  end
end
