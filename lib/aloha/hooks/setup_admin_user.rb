module Aloha
  module Hooks
    class SetupAdminUser
      def call client, data
        users_list = client.web_client.users_list
        slack_admins = users_list.members.select { |u| u.is_admin? }
        slack_admins.each do |admin|
          new_record = !User.exists?(slack_id: admin.id)
          @user = User.find_create_or_update_by_slack_id!(client, admin.id)
          @user.update_attributes! is_admin: true
          if new_record
            welcome_new_admin(client)
          end
        end
      end

      def welcome_new_admin client
        client.web_client.chat_postMessage(channel: "@#{@user.username}", 
                                           as_user: true, 
                                           text: "Welcome to paradise! Aloha is up and running. Type *help* for a list of commands.", 
                                           attachments: [Aloha::Commands::Help::ALOHA_ATTACHMENT], 
                                           link_names: true)
      end
    end
  end
end