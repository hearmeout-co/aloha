require 'open-uri'

module Aloha
  class Server < SlackRubyBotServer::Server

    HOOK_HANDLERS = {
      team_join: Aloha::Hooks::WelcomeNewUser.new,
      presence_change: [Aloha::Hooks::DeliverMessages.new]
    }

    def initialize(options)
      options.merge!(hook_handlers: HOOK_HANDLERS)
      super(options)
      spawn_bot
    end

    def spawn_bot
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

    def self.say client, username, text, options={}
      options.merge!(text: text, channel: "@#{username}", as_user: true, link_names: true)
      client.web_client.chat_postMessage(options)
    end
  end
end