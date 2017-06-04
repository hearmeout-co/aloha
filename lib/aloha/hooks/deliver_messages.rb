module Aloha
  module Hooks
    class DeliverMessages
      def call client, message
        return if message.presence == 'active'
        return if client.users[message.user].name == client.name

        user_id = client.users[message.user].id
        user = User.find_by(slack_id: user_id)
        
        if user
          Message.all.each do |msg|
            msg.deliver!(client, user)
          end
        end
      end
    end
  end
end