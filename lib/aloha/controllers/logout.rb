module Aloha
  class Web < Sinatra::Base
    post '/logout' do
      session.clear
      redirect '/'
    end
  end
end