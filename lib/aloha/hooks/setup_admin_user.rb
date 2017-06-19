module Aloha
  module Hooks
    class SetupAdminUser
      def call client, data
        slack_user = client.users.values.find { |u| u.name == ENV['ADMIN_USERNAME'] }
        user = User.where(slack_id: slack_user.id).first_or_initialize
        user.username = slack_user.name
        user.is_admin = true
        user.save!
        client.web_client.chat_postMessage(channel: "@#{user.username}", 
                                           as_user: true, 
                                           text: "Welcome to paradise! Aloha is up and running. Type *help* for a list of commands.", 
                                           attachments: [Aloha::Controller::ALOHA_ATTACHMENT], 
                                           link_names: true)
      end
    end
  end
end