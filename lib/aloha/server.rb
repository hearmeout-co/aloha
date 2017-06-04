require 'open-uri'

module Aloha
  class Server < SlackRubyBot::Server

    HOOK_HANDLERS = {
      hello: Aloha::Hooks::LoadMessages.new,
      team_join: Aloha::Hooks::WelcomeNewUser.new,
      presence_change: Aloha::Hooks::DeliverMessages.new
    }

    def self.try_send_message client, label, text, id, username
      message = Message.find_by(label: label)
      user = User.find_by(slack_id: id)
      if user.ready_for?(message) && !user.received?(message)
        say(client, username, text)
        Delivery.where(message: message, user: user).first_or_create!
      end
    end

    def self.initialized?(username)
      return User.where(username: username).exists?
    end

    def self.welcome_new_user client, id, username
      user = User.where(slack_id: id).first_or_initialize
      user.username = username
      user.save!

      say(client, username, "Welcome to #{client.team.name}!")
      Message.all.each do |msg|
        msg.deliver!(client, user)
      end
    end

    def self.say client, username, text, options={}
      options.merge!(text: text, channel: "@#{username}", as_user: true, link_names: true)
      client.web_client.chat_postMessage(options)
    end

    def self.messages; @messages; end

  end
end
