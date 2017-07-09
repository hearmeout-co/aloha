require 'slack_markdown'

module Aloha
  module Presenters
    module MessagePresenter
      def readable_delay(message)
        message.delay || 'Right away'
      end

      def content_as_html(message)
        @slack_processor ||= SlackMarkdown::Processor.new(asset_root: '/')
        @slack_processor.call(message.content)[:output].to_s
      end
    end
  end
end