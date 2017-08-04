module Aloha
  module Hooks
    # API docs: https://api.slack.com/events/team_join
    class WelcomeNewUser < Aloha::Hooks::Base
      def invoke client, data
        user = ::User.find_create_or_update_by_slack_id!(client, data.user.id)
        send_welcome(client, user)
      end

      def send_welcome(client, user)
        Aloha::Hooks::DeliverMessages.new.deliver_unread_messages(client, user.slack_id)
      end
    end
  end
end