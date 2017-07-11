module Aloha
  class Web < Sinatra::Base
    get '/welcome' do
      require_login!
      erb :welcome
    end
  end
end