class CreateFields < ActiveRecord::Migration[6.0]
  def change
    create_table :fields do |t|
      t.string :text_theme, default: "", comment: "文字お題"
      t.integer :status, default: 0, comment: "お題ステータス"

      t.timestamps
    end
  end
end
