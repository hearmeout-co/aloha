module Aloha
  class Controller < SlackRubyBot::MVC::Controller::Base
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

    def join
      user_id = client.users[data.user].id
      username = client.users[data.user].name
      user = User.find_by(slack_id: user_id)
      if user.nil?
        Aloha::Hooks::WelcomeNewUser.new.call(client, data)
      else
        Aloha::Server.say(client, username, "It looks like you've already joined! You'll hear from me eventually.")
      end
    end

    def refresh
      Aloha::Hooks::LoadMessages.new.call(client, data)
      username = client.users[data.user].name
      Aloha::Server.say(client, username, "Refreshed! There are #{Message.count} total messages.")
    end

    def update
      username = client.users[data.user].name
      attachments = [
        { fallback: "Find your app name on Heroku at https://dashboard.heroku.com/apps",
          title: "Find Your App Name on Heroku",
          title_link: "https://dashboard.heroku.com/apps"
        }
      ]
      Aloha::Server.say(client, username, "Before we start, you'll need to know your app name. Check your Heroku Dashboard to find it:", attachments: attachments)
      attachments = [
        { fallback: "Install Git for Mac OS X at http://git-scm.com/download/mac",
          title: "Install Git on Mac OS X",
          title_link: "http://git-scm.com/download/mac"
        },
        { fallback: "Install Git for Windows at http://git-scm.com/download/windows",
          title: "Install Git on Windows",
          title_link: "http://git-scm.com/download/windows"
        }
      ]
      Aloha::Server.say(client, username, "*Step 1:* Install Git:", attachments: attachments)
      attachments = [
        { fallback: "Install Heroku for Mac OS X at https://devcenter.heroku.com/articles/heroku-cli#mac",
          title: "Install Heroku on Mac OS X",
          title_link: "https://devcenter.heroku.com/articles/heroku-cli#mac"
        },
        { fallback: "Install Heroku for Windows at https://devcenter.heroku.com/articles/heroku-cli#windows",
          title: "Install Heroku on Windows",
          title_link: "https://devcenter.heroku.com/articles/heroku-cli#windows"
        }
      ]
      Aloha::Server.say(client, username, "*Step 2:* Install Heroku", attachments: attachments)

      content = <<TEXT
*Step 3:* Login to Heroku

Open up Terminal.app and paste in the following, then press ENTER:
```
heroku login
```
TEXT
      Aloha::Server.say(client, username, content)

      content = <<TEXT
*Step 4:* Clone the Latest Version of Aloha
```
git clone https://github.com/ftwnyc/aloha.git && cd aloha
```
TEXT
      Aloha::Server.say(client, username, content)

      content = <<TEXT
*Step 5:* Push to Heroku
```
heroku git:remote -a YOUR_APP_NAME_HERE && git push heroku master
```
_Don't forget to replace the placeholder text above with your app name!_
TEXT
      Aloha::Server.say(client, username, content)
    end

    def self.general_text
      bot_desc = SlackRubyBot::CommandsHelper.instance.bot_desc_and_commands
      other_commands_descs = SlackRubyBot::CommandsHelper.instance.other_commands_descs
      <<TEXT
#{bot_desc.join("\n")}

*More information:*
TEXT
    end

  end
end