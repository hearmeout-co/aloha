module Aloha
  module Commands
    class Update < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
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
    end
  end
end
