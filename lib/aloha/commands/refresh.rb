module Aloha
  module Commands
    class Refresh < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        Aloha::Hooks::LoadMessages.new.call(client, data)
        username = client.users[data.user].name
        Aloha::Server.say(client, username, "Refreshed! There are #{Message.count} total messages.")
      end
    end
  end
end
