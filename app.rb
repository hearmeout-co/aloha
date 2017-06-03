$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'slack-ruby-bot'

require 'aloha/db'

require 'aloha/hooks'
require 'aloha/models'

require 'aloha/bot'
require 'aloha/server'
require 'aloha/web'

$ROOT_FOLDER = File.dirname(__FILE__)