module Aloha
  class Web < Sinatra::Base
    before /\/messages\/?.*?/ do
      require_login!
    end

    get '/messages' do
      @messages = Message.for_users.where(team: current_user.team).all
      erb :'messages/index'
    end
  end
end