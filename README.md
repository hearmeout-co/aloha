# Aloha

Aloha is a welcome bot that's easy to set up and customize. It reads messages from a JSON file you provide and sends them to new members after signing up.

Each message can have an optional delay, so you can space them out just like a [drip marketing campaign](https://en.wikipedia.org/wiki/Drip_marketing).

## Getting Started

### Set Up a Slack Bot User

To start using Aloha, [set up a Bot User](https://my.slack.com/services/new/bot) in your Slack team's custom integrations settings. (You'll need administrator permissions to do this.)

For best results, you should probably give your bot a personality. Choose a username, avatar, and first/last name that makes sense for the type of bot you have in mind. 

When you're done, copy the API token—you'll need it for the next step.

### Set Up Onboarding Messages

Onboarding messages are stored in a JSON configuration file. See the [sample file](https://github.com/ftwnyc/aloha/blob/master/config/messages.json) for an example of the format.

The file is an array of message objects. Each message has three properties:

- `text`: The message text. *IMPORTANT: Escape linebreaks with `\n`.*
- `label`: A short label. This is used for tracking which messages have already been presented to each user.
- `delay`: An optional delay for the message, formatted as a plain-text duration, e.g. "10 seconds", "30 minutes", or "60 days". Messages will be sent as soon as the user becomes active after the delay has passed.

Once you've created the JSON file with your messages, save it as a [gist](https://gist.github.com/), and make sure it's publicly accessible. 

Finally, click the "Raw" button in the top-right corner of the frame to get a link to the raw file—you'll need it for the next step.

### Deploy Aloha to Heroku

The easiest way to install Aloha is through Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

You'll need to fill out two environment variables with the values you saved from the first two steps:

- `SLACK_API_TOKEN`: The API token from your Slack bot setup.
- `MESSAGES_CONFIG_FILE`: The link to the JSON file.

### Deploy Aloha to a Server You Control

Aloha is just a [Rack](https://github.com/rack/rack) app. 

To deploy on a server you control, follow the instructions for [deploying a typical Sinatra app](http://recipes.sinatrarb.com/p/deployment).

Make sure to include the environment variables above when setting up the app.

## Testing

Install [rerun](https://github.com/alexch/rerun), then run the following command to run the tests:

    rerun --no-notify 'bundle exec rake test'