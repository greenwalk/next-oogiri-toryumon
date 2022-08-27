class CreateOogiris < ActiveRecord::Migration[6.0]
  def change
    create_table :oogiris do |t|
      t.string :content, null: false, limit: 200, default: "", comment: "回答"
      t.integer :point, null:false, default: 0, comment: "得点"
      t.integer :score, null: false, default: 0, comment: "スコア"
      t.integer :get_rank, null: false, default: 0, comment: "順位"
      t.references :user , null: false, foreign_key: true
      t.references :field , null: false, foreign_key: true

      t.timestamps
    end
  end
end
