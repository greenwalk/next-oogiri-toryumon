class UserMonstersController < ApplicationController
  before_action :redirect_to_registration_twitter_page
  def create
    user = User.find(params[:user_monster][:user_id])
    if user == current_user
      user_monster = UserMonster.new(user_id: params[:user_monster][:user_id], monster_id: params[:user_monster][:monster_id])
      if user_monster.save
        Monster.find(params[:user_monster][:monster_id]).status_used!
        flash[:success] = "モンスターを生成しました！"
      else
        flash[:danger] = "モンスターの生成に失敗しました。"
      end
    else
      flash[:danger] = "自分のモンスターの生成してください。"
    end
    redirect_to user_path(user)
  end

  def update
    user = User.find(params[:user_monster][:user_id])
    if user == current_user
      now_user_monster = user&.user_monsters&.status_now&.first
      user_monster = UserMonster.new(user_id: params[:user_monster][:user_id], monster_id: params[:user_monster][:monster_id])
      if user_monster.save
        # 一個前のuser_monsterとmonsterのステータスを変える
        now_user_monster&.status_past!
        now_user_monster&.monster&.status_unused!
        Monster.find(params[:user_monster][:monster_id]).status_used!
        user.update!(monster_charge: user.monster_charge - 4)
        if now_user_monster.monster.level == user_monster.monster.level
          flash[:danger] = "残念！レベルアップに失敗しました"
        elsif user_monster.monster.level == 0
          flash[:success] = "新しいモンスターの生成に成功しました！"
        else
          flash[:success] = "おめでとう！レベルアップに成功しました！"
        end
      else
        flash[:danger] = "モンスターの生成に失敗しました。"
      end
    else
      flash[:danger] = "自分のモンスターの生成してください。"
    end
    redirect_to user_path(user)
  end

  private
  def redirect_to_registration_twitter_page
    redirect_to registration_twitter_user_path(current_user.id) unless current_user&.twitter_url&.present?
  end
end
