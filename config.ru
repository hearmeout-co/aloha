ENV['ROOT_FOLDER'] ||= File.dirname(__FILE__)
ENV['RACK_ENV'] ||= 'development'

require_relative 'app'

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