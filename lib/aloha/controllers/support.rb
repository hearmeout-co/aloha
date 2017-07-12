module Aloha
  class Web < Sinatra::Base
    get '/support' do
      erb :support
    end
  end
end