module Aloha
  module Hooks
    # API docs: https://api.slack.com/events/presence_change
    class DeliverMessages < Aloha::Hooks::Base
 
      MESSAGE_LIMIT = 2 # limit the bot from flooding users with more than 2 messages at a time

      def invoke client, data
        return if data.presence != 'active'
        # handles both data.users and data.user in case of batched presence change events
        user_ids = data.users || [data.user]
        user_ids.each do |slack_id|
          deliver_unread_messages(client, slack_id)
        end
      end

      def deliver_unread_messages client, slack_id
        user = ::User.find_by(slack_id: slack_id)
        if user
          messages_sent = 0
          Message.where(team: user.team).order(:delay).each do |message|
            if messages_sent < MESSAGE_LIMIT
              if message.deliver!(client, user)
                messages_sent += 1
              end
            end
          end
        end
      end
    end
  end
end