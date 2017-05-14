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
        messages.each do |msg|
          say(client, username, msg["text"])
        end
      end
    end

    def self.say client, username, text, options={}
      options.merge!(text: text, channel: "@#{username}", as_user: true, link_names: true)
      client.web_client.chat_postMessage(options)
    end

    def self.load_messages!
      config_file = ENV['MESSAGES_CONFIG_FILE'] || File.join($ROOT_FOLDER, "config/messages.json")
      data = open(config_file).read
      @messages = JSON::parse(data)
    end

    def self.messages; @messages; end
  end
end

