module Aloha
  class Controller < SlackRubyBot::MVC::Controller::Base
    def refresh
      Aloha::Hooks::LoadMessages.new.call(client, data)
      username = client.users[data.user].name
      Aloha::Server.say(client, username, "Refreshed! There are #{Message.count} total messages.")
    end
  end
end