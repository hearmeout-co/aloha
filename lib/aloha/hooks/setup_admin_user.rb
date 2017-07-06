module Aloha
  module Hooks
    class SetupAdminUser
      HEROKU_POST = {
        fallback: "Heroku article on free dyno hours: https://devcenter.heroku.com/articles/free-dyno-hours",
        author_name: "Heroku Dev Center",
        author_link: "https://devcenter.heroku.com",
        title: "Free Dyno Hours",
        text: "Accounts are given a base of 550 hours each month in which your Free dynos can run. In addition to these base hours, accounts which verify with a credit card will receive an additional 450 hours of Free dyno quota.",
        title_link: "https://devcenter.heroku.com/articles/free-dyno-hours",
        color: "warning"
      }

      PINGDOM_ATTACHMENT = {
        fallback: "Pingdom can keep your site running for free: https://www.pingdom.com/",
        title: "Pingdom",
        text: "You can use Pingdom to keep your free app alive.",
        title_link: "https://www.pingdom.com/",
        color: "good"
      }

      def call client, data
        slack_user = client.users.values.find { |u| u.name == ENV['ADMIN_USERNAME'] }
        @user = User.where(slack_id: slack_user.id).first_or_initialize
        @user.username = slack_user.name
        @user.is_admin = true
        if @user.new_record?
          welcome_new_admin(client)
        end
        @user.save!
      end

      def welcome_new_admin client
        client.web_client.chat_postMessage(channel: "@#{@user.username}", 
                                           as_user: true, 
                                           text: "Welcome to paradise! Aloha is up and running. Type *help* for a list of commands.", 
                                           attachments: [Aloha::Commands::Help::ALOHA_ATTACHMENT], 
                                           link_names: true)

        client.web_client.chat_postMessage(channel: "@#{@user.username}", 
                                           as_user: true, 
                                           text: "Using a free Heroku account? To ensure uptime, upgrade to a paid plan or read this now:", 
                                           attachments: [HEROKU_POST, PINGDOM_ATTACHMENT], 
                                           link_names: true)
      end
    end
  end
end