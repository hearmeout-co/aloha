module Aloha
  module Hooks
    class SetupAdminUser
      def call client, data
        slack_user = client.users.values.find { |u| u.name == ENV['ADMIN_USERNAME'] }
        user = User.where(slack_id: slack_user.id).first_or_initialize
        user.username = slack_user.name
        user.is_admin = true
        user.save!
      end
    end
  end
end