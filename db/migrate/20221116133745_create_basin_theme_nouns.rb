class CreateBasinThemeNouns < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_theme_nouns do |t|
      t.string :noun_word, default: "", null: false, comment: "名詞"

      t.timestamps
    end
  end
end
