module Aloha
  class Web < Sinatra::Base
    before Regexp.new("/app/auth/.+") do
      @state = SecureRandom.hex(32)
      session[:slack_oauth_state] = @state
    end

    get '/app/auth/install' do
      redirect destination("bot", "/app/install")
    end

    get '/app/auth/login' do
      redirect destination("identity.basic", "/app/login")
    end

    helpers do
      def destination(scope, redirect_uri)
        url = "https://slack.com/oauth/authorize?" +
              "scope=#{scope}" +
              "&client_id=#{ENV['SLACK_CLIENT_ID']}" +
              "&redirect_uri=#{URI.escape(ENV['BASE_URL'] + redirect_uri)}" +
              "&state=#{@state}"
      end
    end
  end
end
