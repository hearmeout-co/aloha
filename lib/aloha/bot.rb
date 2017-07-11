module Aloha
  class Bot < SlackRubyBot::Bot
    help do
      title 'Aloha Bot'
      desc 'Aloha helps onboard new team members with scheduled messages.'

      command 'join' do
        desc 'Opt-in to Aloha messaging.'
      end

      command 'refresh' do
        desc 'Refresh messages after updating the configuration.'
      end

      command 'update' do
        desc 'Get help updating the bot to the latest version on Heroku.'
      end
    end
  end
end