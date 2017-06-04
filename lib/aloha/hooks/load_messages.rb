module Aloha
  module Hooks
    class LoadMessages
      def call client, message
        config_file = ENV['MESSAGES_CONFIG_FILE'] || File.join($ROOT_FOLDER, "config/messages.json")
        data = open(config_file).read
        messages = JSON::parse(data)
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