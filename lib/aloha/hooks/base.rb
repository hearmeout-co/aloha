module Aloha
  module Hooks
    class Base
      def call client, data
        begin
          invoke(client, data)
        rescue StandardError => e
          Raven.capture_exception(e)
          logger.info "#{name}: #{client.owner}, #{e.class}: #{e}"
          raise e
        end
      end

      def invoke client, data
        raise "Aloha::Hooks::Base#invoke must be defined in a subclass"
      end
    end
  end
end
