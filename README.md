# Aloha

Aloha is a welcome bot that's easy to set up and customize. It sends helpful onboarding messages to new members after signing up.

Each message can have an optional delay, so you can space them out just like a [drip marketing campaign](https://en.wikipedia.org/wiki/Drip_marketing).

## Getting Started with Local Development

### Install Dependencies

Aloha is a [Rack](https://github.com/rack/rack) app. Before you start, if you don't have Ruby and Rack installed, follow the instructions for [setting up a typical Rails installation with Postgresql](https://gorails.com/setup/osx/10.12-sierra).

### Create a Slack App for Development

To work locally, you'll need to [create a Slack app](https://api.slack.com/slack-apps#creating_apps) for development. Once you've created it, go to **App Credentials** under **Basic Information** and copy the **Client ID** and **Client Secret**.

### Clone the Repo

    git clone https://github.com/ftwnyc/aloha && cd aloha

### Set up Environment Variables

Add the following environment variables to your `.env` or `.bash_profile`, replacing the placeholders with the ID and secret you copied from your Slack app.

    SLACK_CLIENT_ID=[SLACK_CLIENT_ID]
    SLACK_CLIENT_SECRET==[SLACK_CLIENT_SECRET]
    RACK_ENV=development
    LANG=en_US.UTF-8

### Install Gems

    bundle

### Create and Migrate the Database

    rake db:create db:migrate

### Start the App

    bundle exec rackup

### Open the Running App

Go to http://localhost:9292 and click **Add to Slack** to add your team to the local app and get started.

## Testing

Install [rerun](https://github.com/alexch/rerun), then run the following command to run the tests:

    rerun --no-notify 'bundle exec rake test'