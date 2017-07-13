module Aloha
  class Web < Sinatra::Base
    get '/app/welcome' do
      require_login!
      erb :welcome
    end
  end
end