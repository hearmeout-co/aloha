module Aloha
  class Web < Sinatra::Base
    post '/app/logout' do
      session.clear
      redirect '/'
    end
  end
end