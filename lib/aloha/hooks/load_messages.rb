module Aloha
  module Hooks
    class LoadMessages
      def call client, data
        config_file = ENV['MESSAGES_CONFIG_FILE'] || File.join($ROOT_FOLDER, "config/messages.json")
        json = open(config_file).read
        messages = JSON::parse(json)
        messages.each do |msg|
          message = Message.where(label: msg["label"]).first_or_initialize
          message.content = msg["text"]
          message.delay = msg["delay"]
          message.save!
        end
      end
    end
  end
end