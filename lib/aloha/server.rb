require 'open-uri'

module Aloha
  class Server < SlackRubyBotServer::Server

    HOOK_HANDLERS = {
      hello: [Aloha::Hooks::LoadMessages.new, Aloha::Hooks::SetupAdminUser.new, Aloha::Hooks::CheckForUpdates.new],
      team_join: Aloha::Hooks::WelcomeNewUser.new,
      presence_change: [Aloha::Hooks::DeliverMessages.new, Aloha::Hooks::CheckForUpdates.new]
    }

    def self.say client, username, text, options={}
      options.merge!(text: text, channel: "@#{username}", as_user: true, link_names: true)
      client.web_client.chat_postMessage(options)
    end
  end
end