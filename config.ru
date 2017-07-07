ENV['RACK_ENV'] ||= 'development'

require_relative 'app'

SlackRubyBotServer::App.instance.prepare!
SlackRubyBotServer::Service.start!

run SlackRubyBotServer::Api::Middleware.instance

require 'sass/plugin/rack'

use Sass::Plugin::Rack

use Rack::Static,
  urls: ['/stylesheets'],
  root: File.expand_path('../tmp', __FILE__)

Sass::Plugin.options.merge!(template_location: 'public/stylesheets',
                          css_location: 'tmp/stylesheets')

require_relative 'web'
run Aloha::Web.new