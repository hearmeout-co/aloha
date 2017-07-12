module Aloha
  module Hooks
    # API docs: https://api.slack.com/events/presence_change
    class DeliverMessages
      def call client, data
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
          Message.all.each do |message|
            message.deliver!(client, user)
          end
        end
      end
    end
  end
end