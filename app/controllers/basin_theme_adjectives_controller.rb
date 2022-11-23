class BasinThemeAdjectivesController < ApplicationController
  def upload

  end

  def import
    upload_file = params[:file].path
    json = ActiveSupport::JSON.decode(File.read(upload_file))
    json.each do |data|
      # 下記を追記
      @adjective = BasinThemeAdjective.new(
        adjective_word: data['adjective_word']
      )

      # 確認
      if @adjective.save
        p 'DB保存に成功'
      else
        p 'DB保存に失敗'
      end
    end
    redirect_to basin_theme_adjectives_upload_path
  end
end
