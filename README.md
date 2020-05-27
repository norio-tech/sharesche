# アプリ名
シェアッシュ
# 概要
スケジュール共有アプリです。
作成したスケジュールを複数人で共有することができます。
また、複数のスケジュールをリストにまとめ、
1つのカレンダー上で複数のスケジュール情報を確認できます。
# デプロイURL
https://tech-fuka-product01.herokuapp.com/
# テストアカウント
ID:test@test
PASS:11111111
# 使用イメージ

他ユーザーのスケジュールを参照する
<img src="https://github.com/norio-tech/sharesche/blob/images/preview.gif?raw=true">
# 制作背景
プログラミングスクールに通い自分でWebアプリを作成できるようになったため、どうせなら自分自身が利用できるアプリを作成しようと思いスケジュール共有アプリを作成しました。

# 工夫したポイント
通常のスケジュール共有アプリでは、共有するメンバーごとにスケジュールを分けて管理する必要がありましたが、このアプリでは複数のスケジュールをリスト化して1つのカレンダー上で予定を確認することができます。

# 使用した技術
Ruby on Rails
# 使用したgem
・devise
・holiday_japan


# DB設計
## userテーブル
|Column |Type |Option|
|------------|------|----------|
|name |string |null: false|
|email |string |null: false|
|password |string |null: false|
|image_name |string ||

## scheduleテーブル
|Column |Type |Option|
|------------|------|----------|
|name |string |null: false|
|user_id |integer |null: false|
|message |text ||
|is_password |boolean |null: false,default: false|
|password |string ||
|sharesche_key |string ||
|chkdig |string ||

## planテーブル
|Column |Type |Option|
|------------|------|----------|
|schedule_id |integer |null: false|
|title |string |null: false|
|plan_day |date |null: false|
|start_time |time ||
|end_time |time ||
|place |string ||
|content |text ||

## followテーブル
|Column |Type |Option|
|------------|------|----------|
|user_id |integer |null: false|
|schedule_id |integer |null: false|
|schedule_chkdig |string ||
|schedule_sharesche_key |string |null: false|

## commentテーブル
|Column |Type |Option|
|------------|------|----------|
|user_id |integer |null: false|
|user_id |integer |null: false|
|message |text ||

## listテーブル
|Column |Type |Option|
|------------|------|----------|
|user_id |integer |null: false|
|name |string |null: false|

## list_scheduleテーブル
|Column |Type |Option|
|------------|------|----------|
|list_id |integer |null: false|
|schedule_id |integer |null: false|




