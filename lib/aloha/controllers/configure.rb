module Aloha
  class Web < Sinatra::Base
    post '/configure' do
      @messages = params[:messages]
      erb :configure
    end
  end
end