require 'chronic'
require 'open-uri'
require 'pstore'

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
          if msg["delay"].nil?
            say(client, username, msg["text"])
          end
        end
      end
    end

    on 'presence_change' do |client, message|
      username = client.users[message.user].name
      if username != client.name && message.presence == 'active'
        messages.each do |msg|
          next if msg["delay"].nil?
          store.transaction do

            # initialize a record for the user if none exists
            store[username] ||= {}
            store[username]["created_at"] ||= Time.now
            store[username]["messages_received"] ||= []

            # has the user gotten this message already?
            skip = store[username]["messages_received"].include?(msg["label"])

            # has the delay passed?
            time_with_delay = Chronic.parse(msg["delay"] + " ago")
            skip ||= store[username]["created_at"] < time_with_delay
            unless skip
              say(client, username, msg["text"])
              store[username]["messages_received"] << msg["label"]
            end
          end
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

    def self.store
      @store ||= PStore.new("aloha.pstore")
    end
  end
end
