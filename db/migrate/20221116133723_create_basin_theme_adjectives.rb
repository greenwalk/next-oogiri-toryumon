class CreateBasinThemeAdjectives < ActiveRecord::Migration[6.0]
  def change
    create_table :basin_theme_adjectives do |t|

      t.timestamps
    end
  end
end
