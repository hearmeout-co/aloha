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

      user_client = Slack::Web::Client.new(token: token)

      identity = user_client.users_identity
      team_id = identity['team']['id']
      user_id = identity['user']['id']

      team = Team.where(team_id: team_id).first
      if team && !team.active?
        team.activate!(token)
      elsif !team
        raise "No team with ID #{team_id}"
      else
        rt_client = Slack::RealTime::Client.new(token: team.token)
        user = User.find_create_or_update_by_slack_id!(rt_client, user_id, team)
        user.update_attributes!(token: token)
      end

      session[:slack_user_token] = token
      redirect '/welcome'
    end
  end
end