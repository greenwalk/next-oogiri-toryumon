namespace :test_task do
  desc "テスト用task"
  task :test => :environment do
    user = User.first
    Rails.logger.info(user.name)
  end
end
