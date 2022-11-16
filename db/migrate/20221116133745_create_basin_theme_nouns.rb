class CreateBasinThemeNouns < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_theme_nouns do |t|

      t.timestamps
    end
  end
end
