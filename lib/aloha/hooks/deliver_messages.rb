module Aloha
  module Hooks
    # API docs: https://api.slack.com/events/presence_change
    class DeliverMessages < Aloha::Hooks::Base
      def invoke client, data
        return if data.presence != 'active'
        # handles both data.users and data.user in case of batched presence change events
        user_ids = data.users || [data.user]
        ActiveRecord::Base.connection_pool.with_connection do
          user_ids.each do |slack_id|
            deliver_unread_messages(client, slack_id)
          end
        end
      end

      def deliver_unread_messages client, slack_id
        user = ::User.find_by(slack_id: slack_id)
        if user
          Message.where(team: user.team).each do |message|
            message.deliver!(client, user)
          end
        end
      end
    end
  end
end