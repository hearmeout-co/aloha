module Aloha
  module Hooks
    class RequestPresenceSubscriptions < Aloha::Hooks::Base
      def invoke client, data
        team = Team.find_by(team_id: client.team.id)
        ids = team.users.order('created_at DESC').limit(500).pluck(:slack_id)
        
        # subscribe to presence events for all users
        client.send("send_json", {type: 'presence_sub', ids: ids})
      end
    end
  end
end