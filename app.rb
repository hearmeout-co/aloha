ENV['ROOT_FOLDER'] ||= File.dirname(__FILE__)
ENV['BASE_URL'] ||= "http://localhost:9292"
ENV['RACK_ENV'] ||= 'development'
ENV['SESSION_SECRET'] ||= 'SESSION_SECRET'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'active_record'

Bundler.require :default

require 'slack-ruby-bot'

require 'aloha/db'
require 'aloha/helpers'

require 'aloha/hooks'
require 'aloha/models'

require 'aloha/ext'
require 'aloha/bot'
require 'aloha/commands'
require 'aloha/server'
require 'aloha/web'

SlackRubyBotServer.configure do |config|
  config.server_class = Aloha::Server
end

SlackRubyBot::Client.logger.level = Logger::DEBUG

$ROOT_FOLDER = File.dirname(__FILE__)