namespace :basin_task do

  desc "【1min毎】滝壺の切り替え処理"
  def update_point_and_rank(oogiris)
    @oogiris = oogiris.includes(:basin_likes).sort { |a, b| b.basin_likes.length <=> a.basin_likes.length }
    @oogiris.map.with_index(1){ |oogiri, i| oogiri.update!(point: oogiri.basin_likes.length, rank: i)}
  end

  task :change_fields_status => :environment do
    begin
      ActiveRecord::Base.transaction do
        # 最新のお題
        field = BasinField.order(updated_at: :desc).first

        #最新お題のステータスによって処理を分岐
        if field.status_posting?
          # 投稿->投票
          not_bot_oogiris = BasinOogiri.includes(:basin_field).where(basin_field: {status: :finished}).where.not(user_id: 529)
          bot_oogiri_content = not_bot_oogiris.offset( rand(not_bot_oogiris.count) ).first.content
          BasinOogiri.create!(content: bot_oogiri_content, user_id: 529, basin_field_id: field.id)
          field.status_voting!
        elsif  field.status_voting?
          # 投票->結果 + oogiriにデータ保存
          field.status_finished!
          update_point_and_rank(field.basin_oogiris)
        elsif field.status_finished?
          # 最新お題の結果が出てたら新しいお題を出題
          adjective = BasinThemeAdjective.where('id >= ?', rand(BasinThemeAdjective.first.id..BasinThemeAdjective.last.id)).first
          noun = BasinThemeNoun.where('id >= ?', rand(BasinThemeNoun.first.id..BasinThemeNoun.last.id)).first
          theme = adjective.adjective_word + noun.noun_word
          BasinField.create!(theme: theme, status: 0)
        end
      end
    rescue => e
      Rails.logger.error(e.message)
    end
  end
end
