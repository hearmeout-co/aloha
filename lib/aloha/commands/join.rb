module Aloha
  module Commands
    class Join < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        slack_id = data.user
        user = ::User.find_by(slack_id: slack_id)
        if user.nil?
          user = User.find_create_or_update_by_slack_id!(client, slack_id)
          Aloha::Hooks::WelcomeNewUser.new.send_welcome(client, user)
        else
          Aloha::Server.say(client, user.username, "It looks like you've already joined! You'll hear from me eventually.")
        end
      end
    end
  end
end
