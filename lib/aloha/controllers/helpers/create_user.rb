module Aloha
  class Web < Sinatra::Base
    helpers do
      def create_and_store_logged_in_user(token, slack_id, team_id)
        user_client = Slack::Web::Client.new(token: token)

        team = Team.where(team_id: team_id).first
        if team && !team.active?
          team.activate!(token)
        end

        if !team
          redirect '/'
        else
          rt_client = Slack::RealTime::Client.new(token: team.token)
          user = User.find_create_or_update_by_slack_id!(rt_client, slack_id, team)
          user.update_attributes!(token: token)
          session[:slack_user_token] = token
          return user
        end
      end
    end
  end
end