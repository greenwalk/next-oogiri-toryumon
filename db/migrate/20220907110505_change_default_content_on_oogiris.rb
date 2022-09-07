class ChangeDefaultContentOnOogiris < ActiveRecord::Migration[6.0]
  def change
    change_column_default :oogiris, :content, nil
  end
end
