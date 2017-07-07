ENV['RACK_ENV'] ||= 'development'

require_relative 'app'

SlackRubyBotServer::App.instance.prepare!
SlackRubyBotServer::Service.start!

run SlackRubyBotServer::Api::Middleware.instance
