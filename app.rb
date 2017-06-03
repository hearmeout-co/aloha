$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'slack-ruby-bot'
require 'aloha/bot'
require 'aloha/server'
require 'aloha/web'
require 'aloha/db'
require 'aloha/models'
require 'aloha/models'

$ROOT_FOLDER = File.dirname(__FILE__)