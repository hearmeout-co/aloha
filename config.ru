require_relative 'app'

if ENV['NEW_RELIC_KEY']
  require 'newrelic_rpm'
end

if ENV['DEBUG']
  configure :production do
    set :logging, Logger::DEBUG
  end
end

if ENV['SENTRY_DSN'].to_s.length > 0
  require 'raven'

  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.sanitize_fields = ["token"]
  end

  use Raven::Rack
end

unless ENV['WEB_ONLY']
  SlackRubyBotServer::App.instance.prepare!
  SlackRubyBotServer::Service.start!

  run SlackRubyBotServer::Api::Middleware.instance
end

unless ENV['BOT_ONLY']
  require 'sass/plugin/rack'

  use Sass::Plugin::Rack

  use Rack::Static,
    urls: ['/stylesheets'],
    root: File.expand_path('../tmp', __FILE__)

  Sass::Plugin.options.merge!(template_location: 'public/stylesheets',
                            css_location: 'tmp/stylesheets')

  run Aloha::Web.new
end