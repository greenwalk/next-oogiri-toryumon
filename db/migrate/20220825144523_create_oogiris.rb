class CreateOogiris < ActiveRecord::Migration[6.0]
  def change
    create_table :oogiris do |t|

      t.timestamps
    end
  end
end
