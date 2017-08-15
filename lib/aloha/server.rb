require 'open-uri'

module Aloha
  class Server < SlackRubyBotServer::Server
    HOOK_HANDLERS = {
      team_join: Aloha::Hooks::WelcomeNewUser.new,
      message: SlackRubyBot::Hooks::Message.new,
      presence_change: [Aloha::Hooks::DeliverMessages.new]
    }

    def initialize(options)
      options.merge!(hook_handlers: HOOK_HANDLERS)
      super(options)
    end
  end
end