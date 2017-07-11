require 'slack_markdown'

module Aloha
  module Presenters
    module MessagePresenter
      def readable_delay(delay)
        return 'Right away' if delay <= 0
        ChronicDuration.output(delay)
      end

      def delay_value(message)
        delay_string = ChronicDuration.output(message.delay, format: :long)
        return 0 if delay_string.nil?
        delay_string.to_i
      end

      def delay_type(message)
        delay_string = ChronicDuration.output(message.delay, format: :long)
        return nil if delay_string.nil?
        delay_string.gsub!(/[0-9\s]/, '')
        # add plural if singular to match the view's <select> options
        delay_string += "s" unless delay_string =~ /s$/
      end

      def content_as_html(message)
        @slack_processor ||= SlackMarkdown::Processor.new(asset_root: '/')
        @slack_processor.call(message.content)[:output].to_s
      end
    end
  end
end