module Aloha
  module Hooks
    class DeliverMessages
      def call client, data
        return if data.presence != 'active'
        user = ::User.find_create_or_update_by_slack_id!(client, data.user)
        if user
          Message.all.each do |message|
            message.deliver!(client, user)
          end
        end
      end
    end
  end
end