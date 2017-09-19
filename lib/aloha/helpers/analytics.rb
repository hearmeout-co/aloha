module Aloha
  module Helpers
    class Analytics

      def self.instance
        @analytics ||= self.new
      end

      def self.increment key, value, attributes={}
        instance.increment(key, value, attributes)
      end

      def databox_client
        return @databox_client unless @databox_client.nil?
        unless ENV['DATABOX_TOKEN'].to_s.empty?
          Databox.configure do |c|
            c.push_token   = ENV['DATABOX_TOKEN']
          end
          @databox_client = Databox::Client.new
        end
        @databox_client
      end

      def increment key, value, attributes={}
        return if ENV['DATABOX_TOKEN'].to_s.empty?
        log_message = "Incrementing analytics event #{key} by value #{value}"
        unless attributes.empty?
          log_message += " and attributes #{attributes.inspect}" 
        end
        STDOUT.puts(log_message)
        begin
          self.databox_client.push(key: key, value: value, attributes: attributes)
        rescue StandardError => e
          Raven.capture_exception(e)
        end
      end

    end
  end
end