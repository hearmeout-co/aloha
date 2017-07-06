module Aloha
  module Commands
    class Join < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user_id = client.users[data.user].id
        username = client.users[data.user].name
        user = User.find_by(slack_id: user_id)
        if user.nil?
          Aloha::Hooks::WelcomeNewUser.new.call(client, data)
        else
          Aloha::Server.say(client, username, "It looks like you've already joined! You'll hear from me eventually.")
        end
      end
    end
  end
end
