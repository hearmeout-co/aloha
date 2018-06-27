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
      # pull all members that aren't restricted, or bots
      all_members = []
      client.web_client.users_list(presence: true, limit: 10) do |response|
        all_members.concat(response.members)
      end
      all_members
      users =  all_members.reject { |u| u.deleted || u.is_bot || u.is_app_user || u.is_restricted || u.name == 'slackbot'  }

      # subscribe to presence events for them
      client.send("send_json", {type: 'presence_sub', ids: users.map(&:id)})      
    end
  end
end