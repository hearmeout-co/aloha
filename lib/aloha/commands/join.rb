module Aloha
  module Commands
    class Join < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        user = ::User.find_create_or_update_by_slack_id!(client, data.user)
        if user.nil?
          Aloha::Hooks::WelcomeNewUser.new.call(client, data)
        else
          Aloha::Server.say(client, user.username, "It looks like you've already joined! You'll hear from me eventually.")
        end
      end
    end
  end
end
