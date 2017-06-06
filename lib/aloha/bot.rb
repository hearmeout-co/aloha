require 'aloha/controller'

module Aloha

  class Bot < SlackRubyBot::Bot
    help do
      title 'Aloha Bot'
      desc 'Aloha helps onboard new team members with scheduled messages.'

      command 'refresh' do
        desc 'Refresh messages after updating the configuration.'
      end

      command 'update' do
        desc 'Get help updating the bot to the latest version on Heroku.'
      end
    end

    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    @controller = Aloha::Controller.new(model, view)
    @controller.class.command_class.routes.each do |route|
      STDERR.puts route.inspect
    end
  end
end