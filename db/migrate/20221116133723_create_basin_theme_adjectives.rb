class CreateBasinThemeAdjectives < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_theme_adjectives do |t|
      t.string :adjective_word, default: "", null: false, comment: "形容詞"

      t.timestamps
    end
  end
end
