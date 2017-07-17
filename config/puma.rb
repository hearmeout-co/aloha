ENV['WEB_CONCURRENCY'] ||= "1"
ENV['SINATRA_MAX_THREADS'] ||= "1"

workers Integer(ENV['WEB_CONCURRENCY'])
threads_count = Integer(ENV['SINATRA_MAX_THREADS'])
threads threads_count, threads_count
preload_app!

rackup      DefaultRackup
port ENV['PORT'] || 9292
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveSupport.on_load(:active_record) do
    config = ActiveRecord::Base.configurations[ENV['RACK_ENV']]
    config['pool'] = ENV['SINATRA_MAX_THREADS'].to_i
    ActiveRecord::Base.establish_connection(config)
  end
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end
