module Aloha
  class Web < Sinatra::Base
    get '/sunset' do
      erb :sunset
    end
  end
end