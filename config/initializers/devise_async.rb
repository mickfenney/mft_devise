# Supported options: :resque, :sidekiq, :delayed_job, :queue_classic, :torquebox
# config/initializers/devise_async.rb
Devise::Async.setup do |config|
  config.backend = :delayed_job
  config.queue   = :devise_email
end