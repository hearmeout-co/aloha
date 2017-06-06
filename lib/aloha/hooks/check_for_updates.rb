require 'http'

module Aloha
  module Hooks
    class InvalidVersionError < Exception; end

    class CheckForUpdates
      REMOTE_VERSION_JSON_URL = "https://raw.githubusercontent.com/ftwnyc/aloha/update-notifications/config/version.json"
      def call client, data
        return if data.presence != 'active'
        return if client.users[data.user].name == client.name

        user_id = client.users[data.user].id
        user = User.find_by(slack_id: user_id)
        
        if user.is_admin?
          latest_version_json = JSON.parse(HTTP.get(REMOTE_VERSION_JSON_URL).to_s)
          current_version_json = JSON.parse(File.open(File.join($ROOT_FOLDER, "config", "version.json")).read)
          if latest_version_json["version"].to_s.blank?
            raise InvalidVersionError.new("Invalid version: #{latest_version_json}")
          end
          if Gem::Version.new(latest_version_json["version"]) > Gem::Version.new(current_version_json["version"])
            create_update_message(latest_version_json["version"])
          end
        end
      end

      def create_update_message version
        message = Message.where(label: "aloha-system-update-v-#{version}").first_or_initialize
        message.content = "*Roll out the gangplank!* Aloha just shipped version #{version}. For help updating, type *update*."
        message.admin_only = true
        message.save!
      end
    end
  end
end