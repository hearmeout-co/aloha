module Aloha
  class Controller < SlackRubyBot::MVC::Controller::Base
    def refresh
      Aloha::Hooks::LoadMessages.new.call(client, data)
      username = client.users[data.user].name
      Aloha::Server.say(client, username, "Refreshed! There are #{Message.count} total messages.")
    end

    def help
      command = match[:expression]

      text = command.present? ? SlackRubyBot::CommandsHelper.instance.command_full_desc(command) 
                              : self.class.general_text
      if command.present?
        client.say(channel: data.channel, text: text)
      else
        attachments = [{
                  fallback: "Visit https://github.com/ftwnyc/aloha for more info.",
                  author_name: "For the Win",
                  author_link: "http://ftw.nyc",
                  author_icon: "https://raw.githubusercontent.com/ftwnyc/aloha/custom-help-command/images/ftw-avatar.png",
                  title: "ftwnyc/aloha",
                  text: "Automated onboarding for Slack. Welcome teammates with scheduled messages to build community and team culture.",
                  footer: "View source on Github",
                  footer_icon: "https://raw.githubusercontent.com/ftwnyc/aloha/custom-help-command/images/GitHub-Mark-120px-plus.png",
                  title_link: "https://github.com/ftwnyc/aloha"
                }]
        client.web_client.chat_postMessage(channel: data.channel, as_user: true, text: text, attachments: attachments, link_names: true)
      end
    end

    def self.general_text
      bot_desc = SlackRubyBot::CommandsHelper.instance.bot_desc_and_commands
      other_commands_descs = SlackRubyBot::CommandsHelper.instance.other_commands_descs
      <<TEXT
#{bot_desc.join("\n")}

To get a help for a command use *help <command>*

*More information:*
TEXT
    end

  end
end