# アプリケーション名
大喜利登竜門

# アプリケーション概要
大喜利登竜門は大喜利の投稿サイトです。

**投稿期間**: お題に対して自分の回答を投稿できる。 
**投票期間**: 自分の好きな回答に投票ができる。

投票期間が終了したお題については、結果を見ることができます。得票数に応じて順位が出ます。

URL:

# 利用方法


1. **ユーザー登録をする**  
   →ヘッダーの新規登録ボタンから登録ページへ行き、必要な項目を入力。

2. **ログインする**  
   →ヘッダーのログインボタンからログインページへ行き、必要な項目を入力。

3. **投稿する**  
   →トップページに投句期間中のお題が表示されている。投句するボタンから投句ページへ行き、俳句を入力。

4. **投票する**  
   →トップページに投票期間中のお題が表示されている。投票するボタンから投票ページへ行き、他の人の投稿に投票できる。

### その他
* **結果を見る**  
  投票期間が終了したお題は、トップページにある過去のお題ボタンから一覧できる。結果を見るボタンからその回の俳句の一覧が得票数順に順位づけられて表示される。

* **ユーザー情報を見る**  
  マイページや各箇所のユーザー名のリンクからユーザーページへ移動することができる。そのユーザーの成績や過去の俳句を見ることができる。

* **俳句の詳細を見る**  
  過去の結果ページやユーザーページに表示されている俳句はリンク化されており、その俳句の詳細ページへ移動することができる。詳細ページでは、その俳句を投稿したお題や、得票数・投票者名などを見ることができる。

# テーブル設計

![ER図](/public/images/touku-room.png)

## usersテーブル
| Column             | Type   | Options                        |
|--------------------| ------ | ------------------------------ |
| email              | string | null: false, unique: true      |
| encrypted_password | string | null: false                    |
| name               | string | null: false                    |
| profile            | text   |                                |


### Association
- has_many :haikus
- has_many :themes
- has_many :votes

## themesテーブル
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| season_id          | integer    | null: false                    |
| status             | integer    | null: false                    |
| user               | reference  | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_one :field

## fieldsテーブル
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| status             | integer    | null: false                    |
| theme              | references | null: false, foreign_key: true |

### Association
- has_many :haikus
- belongs_to :theme

## oogirisテーブル
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| content            | string     | null: false                    |
| user               | references | null: false, foreign_key: true |
| field              | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :field
- has_many :votes
- has_many :comments(予定)

## votesテーブル
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| user               | references | null: false, foreign_key: true |
| haiku              | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :haiku

## commentsテーブル（実装予定予定）
| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| content            | text       | null: false                    |
| user               | references | null: false, foreign_key: true |
| haiku              | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- belongs_to :haiku