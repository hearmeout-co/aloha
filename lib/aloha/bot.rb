module Aloha
  class Bot < SlackRubyBot::Bot
    help do
      title 'Aloha Bot'
      desc 'Aloha helps onboard new team members with scheduled messages.'

      command 'join' do
        desc 'Opt-in to Aloha messaging.'
      end
    end
  end
end