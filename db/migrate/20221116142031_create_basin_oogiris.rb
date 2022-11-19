class CreateBasinOogiris < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_oogiris do |t|
      t.string :content, null: false, limit: 30, default: "", comment: "回答"
      t.references :user , null: false, foreign_key: true
      t.references :basin_field , null: false, foreign_key: true

      t.timestamps
    end
  end
end
