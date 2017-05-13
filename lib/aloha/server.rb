require 'open-uri'

module Aloha
  class Server < SlackRubyBot::Server
    on 'hello' do
      load_messages!
    end

    on 'team_join' do |client, message|
      username = client.users[message.user].name
      if username != client.name
        say(client, username, "Welcome to #{client.team.name}!")
      end
    end

    def self.say client, username, text
      client.web_client.chat_postMessage(text: text, channel: "@#{username}", as_user: true)
    end

    def self.load_messages!
      config_file = ENV['MESSAGES_CONFIG_FILE'] || File.join($ROOT_FOLDER, "config/messages.json")
      data = open(config_file).read
      @messages = JSON::parse(data)
    end

    def self.messages; @messages; end
  end
end

