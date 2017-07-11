$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'active_record'

Bundler.require :default

require 'slack-ruby-bot'

require 'aloha/db'

require 'aloha/hooks'
require 'aloha/models'

require 'aloha/bot'
require 'aloha/commands'
require 'aloha/server'
require 'aloha/web'

SlackRubyBotServer.configure do |config|
  config.server_class = Aloha::Server
end

SlackRubyBot::Client.logger.level = Logger::DEBUG

$ROOT_FOLDER = File.dirname(__FILE__)