$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require 'slack-ruby-bot'
require 'aloha/bot'
require 'aloha/server'
require 'aloha/web'

$ROOT_FOLDER = File.dirname(__FILE__)


Thread.abort_on_exception = true

Thread.new do
  begin
    Aloha::Bot.run
    run Aloha::Server.new
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run Aloha::Web.new