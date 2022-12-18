class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable

  require "open-uri"
  include ActionView::Helpers::SanitizeHelper

  has_many :oogiris
  has_many :votes
  has_many :comments
  has_many :comment_likes
  has_many :basin_oogiris
  has_many :basin_likes
  has_many :user_monsters
  has_many :monsters, through: :user_monsters

  validates :name, presence: true
  validates :oogiri_start, presence: true
  validates :twitter_url, presence: true
  validate :twitter_url_validation

  TWITTER_URL_REGEX = %r{https://twitter\.com\/([a-zA-Z0-9_]+)}

  def admin_user?
    id == 4 || id == 459
  end

  def already_liked?(comment)
    self.comment_likes.exists?(comment_id: comment.id)
  end

  def already_basin_liked?(oogiri)
    self.basin_likes.exists?(basin_oogiri_id: oogiri.id)
  end

  def twitter_user_name
    match_data = twitter_url.match(TWITTER_URL_REGEX)
    if match_data
      # 1番目のグループ（ユーザー名）を取得
      username = match_data[1]
      return username
    else
      return nil
    end
  end

  def now_monster
    user_monsters&.status_now&.first&.monster
  end

  private
  def twitter_url_validation
    # URL のフォーマットが正しいかどうかを検証
    unless twitter_url.match?(TWITTER_URL_REGEX)
      errors.add(:twitter_url, 'の形式が適切ではありません、例を参考にしてください。')
    end
    # URL にクエリパラメータが存在していないかどうかを検証
    uri = URI.parse(twitter_url)
    query_params = Rack::Utils.parse_nested_query(uri.query)
    # URL のスキームとホスト名が正しくない場合は、URL は無効
    unless uri.scheme == "https" && uri.host == "twitter.com"
      errors.add(:twitter_url, 'の形式が適切ではありません、例を参考にしてください。')
    end
    # クエリパラメータが存在する場合はfalse
    unless query_params.empty?
      errors.add(:twitter_url, 'に不正なパラメータを検出しました。')
    end

    # URL のHTMLをサニタイズする
    url = sanitize(twitter_url)
    # URL を実際にアクセスし、ステータスコードが 200 以外の場合は、URL は無効
    open(url) { |f| f.status[0] == "200" }
  rescue => e
    # 例外が発生した場合は、URL は無効
    errors.add(:twitter_url, 'の保存に失敗しました。正しいURLを入力してください。')
  end
end
