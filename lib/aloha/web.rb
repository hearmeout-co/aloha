require 'aloha/controllers/helpers'

require 'aloha/controllers/index'
require 'aloha/controllers/sunset'
require 'aloha/controllers/privacy'
require 'aloha/controllers/support'
require 'aloha/controllers/app'

module Aloha
  class Web < Sinatra::Base
    AUTHENTICATED_ROUTES = ["messages", "welcome", "wizard"]

    configure do
      enable :logging
      
      # allow "delete" method with _method param in POST request
      use Rack::MethodOverride

      set :sessions, true
      set :session_secret, ENV['SESSION_SECRET']
      use Rack::Session::Cookie, :key => 'rack.session',
                                 :domain => URI.parse(ENV['BASE_URL']).host,
                                 :path => '/',
                                 :expire_after => 2592000,
                                 :secret => ENV['SESSION_SECRET']

      require 'rack/protection'
      use Rack::Protection
      use Rack::Protection::EscapedParams

      require 'rack/csrf'
      use Rack::Csrf, raise: true

      set :views, Proc.new { File.join(ENV['ROOT_FOLDER'], "lib", "aloha", "views") }
      set :public_folder, Proc.new { File.join(ENV['ROOT_FOLDER'], "public") }
    end

    before Regexp.new("\/app\/(?:#{AUTHENTICATED_ROUTES.join("|")})\/?.*?") do
      require_login!
    end

    before do
      Raven.extra_context(params: params, url: request.url)
      if current_user
        Raven.user_context(user_id: current_user.id)
        Raven.user_context(team_id: current_user.team.id)
      end
    end

    helpers do
      def current_user
        return nil if session[:slack_user_token].nil?
        @user ||= User.find_by(token: session[:slack_user_token])
      end

      def logged_in?
        session[:slack_user_token] && current_user
      end

      def require_login!
        unless logged_in?
          redirect '/'
        end
      end
    end
  end
end