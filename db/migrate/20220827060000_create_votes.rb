class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :vote_point, null: false, default: 0, comment: "点数"
      t.references :user , null: false, foreign_key: true
      t.references :oogiri, null: false, foreign_key: true

      t.timestamps
    end
  end
end
