require 'open-uri'

module Aloha
  class Server < SlackRubyBotServer::Server
    HOOK_HANDLERS = {
      hello: Aloha::Hooks::RequestPresenceSubscriptions.new,
      team_join: [Aloha::Hooks::WelcomeNewUser.new, 
                  Aloha::Hooks::RequestPresenceSubscriptions.new],
      message: SlackRubyBot::Hooks::Message.new,
      presence_change: Aloha::Hooks::DeliverMessages.new
    }

    def initialize(options)
      options.merge!(hook_handlers: HOOK_HANDLERS)
      super(options)
    end
  end
end