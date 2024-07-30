require 'sidekiq'
require 'sidekiq-scheduler'
require 'sidekiq/web'


Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6380/1' }
  
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../schedule.yml', __FILE__))
    Sidekiq::Scheduler.reload_schedule!
  end
  # Sidekiq::Scheduler.dynamic = true
  # Sidekiq::Scheduler.enabled = true
  # Sidekiq.schedule = YAML.load_file(Rails.root.join('config', 'sidekiq_schedule.yml'))
  # Sidekiq::Scheduler.reload_schedule!
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6380/1' }
end
