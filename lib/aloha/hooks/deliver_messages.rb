module Aloha
  module Hooks
    class DeliverMessages
      def call client, data
        return if data.presence != 'active'
        return if client.users[data.user].name == client.name

        user_id = client.users[data.user].id
        user = User.find_by(slack_id: user_id)
        
        if user
          Message.all.each do |message|
            message.deliver!(client, user)
          end
        end
      end
    end
  end
end