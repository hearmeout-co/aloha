$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'slack-ruby-bot'
require 'aloha/bot'
require 'aloha/server'

$ROOT_FOLDER = File.dirname(__FILE__)

Aloha::Bot.run
run Aloha::Server.new