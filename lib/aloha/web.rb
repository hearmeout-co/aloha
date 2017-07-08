require 'aloha/controllers/index'
require 'aloha/controllers/install'
require 'aloha/controllers/welcome'
require 'aloha/controllers/login'

module Aloha
  class Web < Sinatra::Base
    configure do
      enable :sessions
      set :session_secret, ENV['SESSION_SECRET']
      set :views, Proc.new { File.join(ENV['ROOT_FOLDER'], "lib", "aloha", "views") }
      set :public_folder, Proc.new { File.join(ENV['ROOT_FOLDER'], "public") }
    end

    helpers do
      def require_login!
        if session[:slack_user_token].nil?
          redirect '/'
        end
      end
      
      def require_team_login!
        if session[:slack_team_token].nil?
          redirect '/'
        end
      end
    end
  end
end