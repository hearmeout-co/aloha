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

    def start!
      result = super
      Aloha::Server.request_presence_subscriptions(client)
      result
    end

    def start_async
      result = super
      Aloha::Server.request_presence_subscriptions(client)
      result
    end

    def self.request_presence_subscriptions(client)
      team = Team.find_by(team_id: client.team.id)
      ids = team.users.pluck(:slack_id)
      
      # subscribe to presence events for all users
      client.send("send_json", {type: 'presence_sub', ids: ids})
    end
  end
end