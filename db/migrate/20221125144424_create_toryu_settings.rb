class CreateToryuSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :toryu_settings do |t|

      t.timestamps
    end
  end
end
