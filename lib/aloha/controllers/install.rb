module Aloha
  class Web < Sinatra::Base
    get '/install' do
      client = Slack::Web::Client.new

      raise 'Missing SLACK_CLIENT_ID or SLACK_CLIENT_SECRET.' unless ENV.key?('SLACK_CLIENT_ID') && ENV.key?('SLACK_CLIENT_SECRET')

      rc = client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        redirect_uri: "#{URI.escape(ENV['BASE_URL'])}/install",
        code: params[:code]
      )

      token = rc['bot']['bot_access_token']
      team = Team.where(token: token).first
      team ||= Team.where(team_id: rc['team_id']).first
      if team && !team.active?
        team.activate!(token)
      elsif !team
        team = Team.create!(
          token: token,
          team_id: rc['team_id'],
          name: rc['team_name']
        )
      end

      SlackRubyBotServer::Service.instance.create!(team)
      redirect '/welcome'
    end
  end
end