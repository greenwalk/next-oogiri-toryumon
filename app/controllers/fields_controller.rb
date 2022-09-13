class FieldsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :set_field, only: [:update]
  def index
    @fields = Field.where(status: "finished")
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
end
