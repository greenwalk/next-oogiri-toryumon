# rails change_fields_status:change_fields_status
namespace :change_fields_status do
  desc "お題のステータスを一気に切り替える"
  # 大喜利の得点を保存する
  def update_point(oogiris)
    oogiris.map{|oogiri| oogiri.update(point: oogiri.votes.sum(:vote_point))}
  end

  # 大喜利のスコアを保存する
  def update_score(oogiris)
    #標準偏差stdを求める。
    avg = oogiris.sum(:point) / oogiris.length
    arr1 = oogiris.pluck(:point).map{|x| (x - avg) ** 2}
    std = Math.sqrt(arr1.sum / oogiris.length)
    #配列の要素を偏差値に変換して返す。
    if std == 0
      oogiris.map{|oogiri| oogiri.update(score: 0)}
    else
      oogiris.map{|oogiri| oogiri.update(score: ((oogiri.point - avg) * 10 / std).round(2))}
    end
  end

  # 大喜利の順位を保存する
  def update_get_rank(oogiris)
    @oogiris = oogiris.includes(:votes).sort { |a, b| b.votes.sum(:vote_point) <=> a.votes.sum(:vote_point) }
    @oogiris.map.with_index(1){ |oogiri, i| oogiri.update(get_rank: i)}
  end

  # ユーザーのレートを更新する
  def update_rate(oogiris)
    #rateの偏差値を求める
    user_rates = []
    oogiris.each do |oogiri|
      user_rates << oogiri.user.rate
    end
    avg = user_rates.inject(:+) / oogiris.length
    arr1 = user_rates.map{|x| (x - avg) ** 2}
    std = Math.sqrt(arr1.sum / oogiris.length)
    oogiris.each do |oogiri|
      # レートの偏差値
      if std == 0
        rate_dev = 50
      else
        rate_dev = ((oogiri.user.rate - avg) * 10 / std + 50).round(2)
      end
      if rate_dev >= 60
        if oogiri.score >= 0
          true_score = oogiri.score * 0.6
        else
          true_score = oogiri.score * 1.2
        end
      elsif rate_dev >= 50
        if oogiri.score >= 0
          true_score = oogiri.score * 0.8
        else
          true_score = oogiri.score
        end
      elsif rate_dev >= 40
        if oogiri.score >= 0
          true_score = oogiri.score
        else
          true_score = oogiri.score * 0.8
        end
      else
        if oogiri.score >= 0
          true_score = oogiri.score * 1.2
        else
          true_score = oogiri.score * 0.6
        end
      end
      if oogiri.user.max_rate < oogiri.user.rate + true_score
        oogiri.user.update(max_rate: oogiri.user.rate + true_score)
      end
      oogiri.user.update(rate: oogiri.user.rate + true_score)
    end
  end

  # ユーザーのクラスを更新する
  def update_rate_class(oogiris)
    oogiris.each do |oogiri|
      user = oogiri.user
      case user.rate
      when 1800..1000000
        user.update!(rate_class: "<i class='fa-solid fa-meteor' style='color: #FF6600;'></i>")
      when 1750..1799
        user.update!(rate_class: "<i class='fa-solid fa-bolt-lightning text-warning'></i>")
      when 1700..1749
        user.update!(rate_class: "<i class='fa-solid fa-hurricane' style='color: #3300FF;'></i>")
      when 1650..1699
        user.update!(rate_class: "<i class='fa-solid fa-fire' style='color: #FF0000;'></i>")
      when 1600..1649
        user.update!(rate_class: "<i class='fa-solid fa-hammer' style='color: #000066;'></i>")
      when 1550..1599
        user.update!(rate_class: "<i class='fa-solid fa-heart' style='color: #CC3366;'></i>")
      when 1450..1549
        user.update!(rate_class: "<i class='fa-solid fa-seedling' style='color: #66CC00;'></i>")
      when 1400..1449
        user.update!(rate_class: "<i class='fa-solid fa-bug text-muted'></i>")
      when 1350..1399
        user.update!(rate_class: "<i class='fa-solid fa-virus-covid' style='color: #006600;'></i>")
      else
        user.update!(rate_class: "<i class='fa-solid fa-poop' style='color: #996633;'></i>")
      end
    end
  end

  task :change_fields_status => :environment do
    begin
      ActiveRecord::Base.transaction do
        @fields = []
        # 投票中のお題
        @fields << Field.status_voting
        # 投稿中のお題
        @fields << Field.status_posting
        # 次のお題
        @fields << Field.status_permitted.order(created_at: :asc).limit(2)
        @fields.flatten!

        next unless @fields.length == 6

        @fields.each do |field|
          if field.status_posting?
            next_status = "voting"
          elsif field.status_voting?
            next_status = "finished"
          elsif field.status_waiting?
            next_status = "permitted"
          elsif field.status_permitted?
            next_status = "posting"
          else
            next_status = "posting"
          end
          # お題のステータスを変更
          field.update(status: next_status)
          # お題が出題された時、created_atをその時の時刻にする
          field.update(created_at: Time.zone.now) if field.status_posting?
          # お題が結果発表された時、各パラメータを保存・更新する
          if field.status_finished?
            update_point(field.oogiris)
            update_score(field.oogiris)
            update_get_rank(field.oogiris)
            update_rate(field.oogiris)
            update_rate_class(field.oogiris)
            # お題が投票中になったら、そのお題に回答した人のmonster_chageを+1する
            field.oogiris.each do |oogiri|
              oogiri.user.update!(monster_charge: oogiri.user.monster_charge + 1)
            end
          end
        end
      end
    rescue => e
      Rails.logger.error(e.message)
    end
  end
end
