module Aloha
  module Hooks
    class WelcomeNewUser
      # API docs: https://api.slack.com/events/team_join
      def call client, data
        user = ::User.find_create_or_update_by_slack_id!(client, data.user.id)
        
        Aloha::Server.say(client, user.username, "Welcome to #{client.team.name}!")
        Message.all.each do |message|
          message.deliver!(client, user)
        end
      end
    end
  end
end