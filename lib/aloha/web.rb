require 'sinatra'
require 'gist'

module Aloha
  class Web < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/configure' do
      @messages = params[:messages]
      erb :configure
    end

    post '/deploy' do
      @messages = params[:messages]
      @messages.each_pair do |index, message|
        label = index.to_i == 0 ? "welcome" : "message-#{index}"
        message["label"] = label
        if message["delay"].to_i > 0
          message["delay"] = message["delay"] + " #{message["delay_type"]}"
        else
          message.delete("delay")
        end
        message.delete("delay_type")
      end
      gist = Gist.gist(@messages.values.to_json)
      files = gist["files"]
      messages_config_file = files.values.first["raw_url"]
      env = "env[SLACK_API_TOKEN]=#{params[:slack_token]}" + 
            "&env[MESSAGES_CONFIG_FILE]=#{messages_config_file}" +
            "&env[ADMIN_USERNAME]=#{params[:username]}"
      redirect("https://heroku.com/deploy?template=https://github.com/ftwnyc/aloha&#{env}&")
    end
  end
end