module Aloha
  class Web < Sinatra::Base
    helpers do
      def create_and_store_logged_in_user(token)
        user_client = Slack::Web::Client.new(token: token)

        identity = user_client.users_identity
        team_id = identity['team']['id']
        user_id = identity['user']['id']

        team = Team.where(team_id: team_id).first
        if team && !team.active?
          team.activate!(token)
        elsif !team
          redirect '/'
        else
          rt_client = Slack::RealTime::Client.new(token: team.token)
          user = User.find_create_or_update_by_slack_id!(rt_client, user_id, team)
          user.update_attributes!(token: token)
        end

        session[:slack_user_token] = token
      end
    end
  end
end