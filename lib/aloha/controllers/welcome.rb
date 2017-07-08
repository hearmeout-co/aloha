module Aloha
  class Web < Sinatra::Base
    get '/welcome' do
      erb :welcome
    end
  end
end