class UsersController < ApplicationController
  def show
    # 対象のユーザーを取得
    @users = User.eager_load(:oogiris).where.not(oogiris: {id: nil}).order(rate: :desc)
    @user = User.includes(:oogiris, :votes, :comments).find(params[:id])
    # ユーザーモンスター生成のためのインスタンス
    @user_monster = UserMonster.new
    # 現在のモンスターを取得
    @now_monster = @user.user_monsters&.status_now&.first&.monster
    # 一番最初のモンスターを引くとき
    if @now_monster.nil?
      # レベル0の未使用モンスターをランダムに指定
      first_monster = Monster.status_unused.where(level: 0)
      @monster = first_monster.offset( rand(first_monster.count) ).first
    end
    # 二回目以降にモンスターを引くとき（条件: monster_chargeが4以上溜まっていること）
    if @now_monster.present? && @user.monster_charge >= 4
      # 現在のモンスターのレベルを取得
      now_level = @now_monster.level
      # 現在のモンスターのレベル + 1を取得
      next_level = now_level + 1
      # 現在のモンスターの種族を取得
      now_species = @now_monster.species
      # 50%の確率でレベルアップ、50%の確率でレベルステイしたモンスターをランダムで取得する
      if rand(2) == 0
        monster = Monster.status_unused.where(level: now_level, species: now_species)
      else
        monster = Monster.status_unused.where(level: next_level, species: now_species)
      end
      @monster = monster.offset( rand(monster.count) ).first
    end
    # ユーザーのrate順位(=ランク)
    @user_rank = if @users.index(@user).present?
                   @users.index(@user) + 1
                 else
                   "-"
                 end
    # 終了したお題を取得(分母に使用するため)
    @fields = Field.status_finished.where(updated_at: @user.created_at...Time.zone.now)
    @fields_num = @fields.length
    # ユーザーの大喜利を取得
    @oogiris = Oogiri.includes(:field).where(fields: {status: "finished"}).order(created_at: :desc)
    user_oogiris = @oogiris.where(user_id: @user.id)
    @user_oogiris = user_oogiris.page(params[:page]).per(7)
    @user_oogiris_num = user_oogiris.length
    @first_oogiris = Oogiri.includes(:field).where(get_rank: 1, user_id: @user.id)
    @minus_oogiris = Oogiri.includes(:field).where(point: -10000...0, user_id: @user.id)
    # ユーザーの投票を取得
    @votes = Vote.includes(:user, :field).where(fields: {status: :finished}).group(:user_id, :field_id)
    user_votes = @votes.where(user_id: @user.id)
    @user_votes_num = user_votes.length
    @user_minus_votes_num = Vote.includes(:user, :field).where(fields: {status: :finished}).where(user_id: @user.id, vote_point: -2).length
    # ユーザーのコメントを取得
    user_comments = Comment.includes(oogiri: [:field, :user]).where(oogiris: {fields: {status: :finished}}).where(user_id: @user.id).order(created_at: :desc)
    @user_comments = user_comments.page(params[:page]).per(7)
    @user_comments_num = user_comments.length
    @received_comments = Comment.includes(oogiri: [:user, :field]).where(oogiris: {fields: {status: :finished}})
                                                                  .where.not(user_id: @user.id)
                                                                  .where(oogiris: {user_id: @user.id})
                                                                  .order(created_at: :desc).page(params[:page]).per(7)
    # コメントのgood数
    @user_good_num = CommentLike.includes(:comment).where(comments: {id: user_comments.pluck(:id)}).length
    # ガチャの条件
    @gacha_conditions = @user.monster_charge >= 4 && (@user_comments_num.to_f / @user_votes_num.to_f * 100).round(1) >= 200
  end
end