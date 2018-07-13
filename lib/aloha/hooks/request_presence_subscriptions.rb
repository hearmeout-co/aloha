module Aloha
  module Hooks
    class RequestPresenceSubscriptions < Aloha::Hooks::Base
      def invoke client, data
        team = Team.find_by(team_id: client.team.id)
        ids = []
        team.users.find_in_batches(batch_size: 100) do |batch|
          ids += batch.pluck(:slack_id)
        end
        
        # subscribe to presence events for all users
        client.send("send_json", {type: 'presence_sub', ids: ids})
      end
    end
  end
end