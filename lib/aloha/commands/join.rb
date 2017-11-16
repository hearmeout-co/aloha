module Aloha
  module Commands
    class Join < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        ActiveRecord::Base.connection_pool.with_connection do
          slack_id = data.user
          user = ::User.find_by(slack_id: slack_id)
          if user.nil?
            user = User.find_create_or_update_by_slack_id!(client, slack_id)
            Aloha::Hooks::WelcomeNewUser.new.send_welcome(client, user)
          else
            client.web_client.chat_postMessage(channel: user.im_channel_id, text: "It looks like you've already joined! You'll hear from me eventually.")
          end
        end
      end
    end
  end
end
