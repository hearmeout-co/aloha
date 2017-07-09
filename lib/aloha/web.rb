require 'aloha/controllers/index'
require 'aloha/controllers/install'
require 'aloha/controllers/welcome'
require 'aloha/controllers/login'
require 'aloha/controllers/messages'

module Aloha
  class Web < Sinatra::Base
    configure do
      enable :sessions
      set :session_secret, ENV['SESSION_SECRET']
      set :views, Proc.new { File.join(ENV['ROOT_FOLDER'], "lib", "aloha", "views") }
      set :public_folder, Proc.new { File.join(ENV['ROOT_FOLDER'], "public") }
    end

    helpers do
      def current_user
        @user ||= User.find_by(token: session[:slack_user_token])
      end

      def logged_in?
        session[:slack_user_token] && current_user
      end

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