class FieldsController < ApplicationController
  before_action :authenticate_user!, only: [:now_field_index, :create, :update]
  before_action :set_field, only: [:update]
  helper_method :posted_another_field?
  helper_method :already_voted?
  helper_method :check_oogiris_num
  def index
    @fields = Field.where(status: "finished").order(created_at: :desc)
  end

  def now_field_index
    dw = ["日", "月", "火", "水", "木", "金", "土"]
    # 次の土曜日の21:59が表示されるように分岐
    date = if Date.today.strftime('%a') == "Sat" && [*0..2200].include?(Time.zone.now.strftime('%H%M').to_i)
                  Date.yesterday.next_occurring(:saturday)
                else
                  Date.today.next_occurring(:saturday)
                end
    @deadline = date.strftime("%m/%d(#{dw[date.wday]}) 22:00")
  end

  def create
    @field = Field.new(field_params)
    if @field.save
      redirect_to fields_path
    else
      render "admin/admins/top"
    end
  end

  def update
    if @field.status_posting?
      next_status = "voting"
    elsif @field.status_voting?
      next_status = "finished"
    else
      next_status = "posting"
    end
    if @field.update(status: next_status)
      if @field.status_finished?
        update_point(@field.oogiris)
        update_score(@field.oogiris)
        update_get_rank(@field.oogiris)
        update_rate(@field.oogiris)
        update_rate_class(@field.oogiris)
      end
      redirect_to admin_top_path
    else
      render "admin/admins/top"
    end
  end

  private
  def field_params
    params.require(:field).permit(:text_theme, :status)
  end

  def set_field
    @field = Field.find(params[:id])
  end

  def already_voted?(field)
    field.votes.pluck(:user_id).include?(current_user&.id)
  end

  def posted_another_field?(field)
    Field.includes(:oogiris).where.not(id: field.id).where(created_at: field.created_at.all_day, oogiris: {user_id: current_user.id}).present?
  end

  def check_oogiris_num(field)
    field.oogiris.length < @limit_num || field.oogiris.where(user_id: current_user.id).present?
  end

  def update_point(oogiris)
    oogiris.map{|oogiri| oogiri.update(point: oogiri.votes.sum(:vote_point))}
  end

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

  def update_get_rank(oogiris)
    @oogiris = oogiris.includes(:votes).sort { |a, b| b.votes.sum(:vote_point) <=> a.votes.sum(:vote_point) }
    @oogiris.map.with_index(1){ |oogiri, i| oogiri.update(get_rank: i)}
  end

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
end
