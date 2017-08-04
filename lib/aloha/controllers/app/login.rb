module Aloha
  class Web < Sinatra::Base
    get '/app/login' do
      if params[:state].nil? || params[:state] != session[:slack_oauth_state]
        halt 403, "Missing or invalid state parameter."
      end
      if params[:code].nil?
        redirect '/'
      end

      client = Slack::Web::Client.new

      raise 'Missing SLACK_CLIENT_ID or SLACK_CLIENT_SECRET.' unless ENV.key?('SLACK_CLIENT_ID') && ENV.key?('SLACK_CLIENT_SECRET')

      rc = client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        redirect_uri: "#{URI.escape(ENV['BASE_URL'])}/app/login",
        code: params[:code]
      )

      token = rc['access_token']
      create_and_store_logged_in_user(token, rc.user.id, rc.team.id)
      redirect '/app/messages'
    end
  end
end