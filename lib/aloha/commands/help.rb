module Aloha
  module Commands
    class Help < SlackRubyBot::Commands::Base
      ALOHA_ATTACHMENT = {
                        fallback: "Visit https://github.com/ftwnyc/aloha for more info.",
                        author_name: "For the Win",
                        author_link: "http://ftw.nyc",
                        author_icon: "https://raw.githubusercontent.com/ftwnyc/aloha/custom-help-command/images/ftw-avatar.png",
                        title: "ftwnyc/aloha",
                        text: "Automated onboarding for Slack. Welcome teammates with scheduled messages to build community and team culture.",
                        footer: "View source on Github",
                        footer_icon: "https://raw.githubusercontent.com/ftwnyc/aloha/custom-help-command/images/GitHub-Mark-120px-plus.png",
                        title_link: "https://github.com/ftwnyc/aloha"
                      }

      def self.call(client, data, match)
        attachments = [ALOHA_ATTACHMENT]
        client.web_client.chat_postMessage(channel: data.channel, as_user: true, text: self.general_text, attachments: attachments, link_names: true)
      end

      def self.general_text
        bot_desc = SlackRubyBot::CommandsHelper.instance.bot_desc_and_commands
        <<TEXT
#{bot_desc.join("\n")}

*More information:*
TEXT
      end

    end
  end
end
