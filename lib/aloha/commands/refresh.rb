module Aloha
  module Commands
    class Refresh < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        Aloha::Hooks::LoadMessages.new.call(client, data)
        user = ::User.find_by(slack_id: data.user)
        Aloha::Server.say(client, user.username, "Refreshed! There are #{Message.count} total messages.")
      end
    end
  end
end
