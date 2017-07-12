module Aloha
  class Web < Sinatra::Base
    get '/privacy' do
      erb :privacy
    end
  end
end