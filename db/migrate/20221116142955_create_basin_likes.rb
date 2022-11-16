class CreateBasinLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :basin_oogiri, null: false, foreign_key: true

      t.timestamps
    end
  end
end
