# This is a bit of a hack to avoid outputting 

module SlackRubyBot
  module Commands
    class Base
      class << self
        def invoke(client, data)
          _invoke client, data
        rescue StandardError => e
          Raven.capture_exception(e)
          logger.info "#{name.demodulize.upcase}: #{client.owner}, #{e.class}: #{e}"
          client.say(channel: data.channel, text: "I'm sorry, something's gone wrong.")
          true
        end
      end
    end
  end
end
