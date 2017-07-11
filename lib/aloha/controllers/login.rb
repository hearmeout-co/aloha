module Aloha
  class Web < Sinatra::Base
    get '/login' do
      if params[:code].nil?
        redirect '/'
      end

      client = Slack::Web::Client.new

      raise 'Missing SLACK_CLIENT_ID or SLACK_CLIENT_SECRET.' unless ENV.key?('SLACK_CLIENT_ID') && ENV.key?('SLACK_CLIENT_SECRET')

      rc = client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        redirect_uri: "#{URI.escape(ENV['BASE_URL'])}/login",
        code: params[:code]
      )

      token = rc['access_token']
      create_and_store_logged_in_user(token)
      redirect '/messages'
    end
  end
end