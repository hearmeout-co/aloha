ENV['ROOT_FOLDER'] ||= File.dirname(__FILE__)
ENV['BASE_URL'] ||= "http://localhost:9292"
ENV['RACK_ENV'] ||= 'development'
ENV['SESSION_SECRET'] ||= 'SESSION_SECRET'

if ENV['NEW_RELIC_KEY']
  require 'newrelic_rpm'
end

require_relative 'app'

if ENV['DEBUG']
  configure :production do
    set :logging, Logger::DEBUG
  end
end

unless ENV['WEB_ONLY']
  SlackRubyBotServer::App.instance.prepare!
  SlackRubyBotServer::Service.start!

  run SlackRubyBotServer::Api::Middleware.instance

  Thread.new do
    begin
      Aloha::Bot.run
    rescue Exception => e
      STDERR.puts "ERROR: Bot threw exception #{e}"
      STDERR.puts e.backtrace
      raise e
    end
  end      

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