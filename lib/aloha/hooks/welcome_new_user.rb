module Aloha
  module Hooks
    # API docs: https://api.slack.com/events/team_join
    class WelcomeNewUser < Aloha::Hooks::Base
      def invoke client, data
        info = client.web_client.users_info(user: data.user.id)
        # don't create users for bots!
        unless info.user.is_bot
          user = ::User.find_create_or_update_by_slack_id!(client, data.user.id)
          send_welcome(client, user)
        end
        Aloha::Server.request_presence_subscriptions(client)
      end

      def send_welcome(client, user)
        Aloha::Hooks::DeliverMessages.new.deliver_unread_messages(client, user.slack_id)
      end
    end
  end
end