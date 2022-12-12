require "aws-sdk-s3"

namespace :test_task do
  desc "モンスター画像をS3に保存してレコードを生成するタスク"
  task :upload_img_and_create_monsters => :environment do
    # バケット名を指定
    bucket_name = "oogiri-trm-monster"

    # S3のクライアントを生成
    s3 = Aws::S3::Resource.new(region: "ap-northeast-1")
    s3_put = Aws::S3::Client.new(region: "ap-northeast-1")

    monsters = {
      "イミナ" => "monster1.jpg",
      "ヒョザンヌッヒ" => "monster2.jpg",
      "チュムヤー" => "monster3.jpg"
    }

    # 画像を順番にアップロードする
    monsters.each do |name, path|
      # 画像のファイルパスを作成
      file_path = "/Users/tatsumi/monsters/#{path}"
      if File.exists?(file_path)
        # 画像が存在する場合は、画像を読み込めるかどうかを確認する
        if File.readable?(file_path)
          # 画像が読み込める場合は、画像をS3にアップロードする
          s3_put.put_object(
            bucket: bucket_name,
            key: path,
            body: File.open(file_path)
          )

          # アップロードした画像のURLを取得する
          object = s3.bucket("oogiri-trm-monster").object(path)
          image_url = object.public_url(virtual_host: false)

          # monstersテーブルに画像情報を保存する
          Monster.create(
            name: name,
            status: 0,
            image: image_url
          )
        else
          # 画像が読み込めない場合はエラーを表示する
          puts "画像が読み込めません"
        end
      else
        # 画像が存在しない場合は、エラーを表示する
        puts "画像が存在しません。: #{path}"
      end
    end
  end
end
