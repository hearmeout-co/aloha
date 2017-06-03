require File.expand_path '../test_helper.rb', __FILE__

class ServerTest < AlohaTest

  test 'server welcomes new user with team name' do
    setup_client
    @web_client.expects(:chat_postMessage).at_least_once
    options = { text: "Welcome to Aloha!", channel: "@ben", as_user: true, link_names: true }
    @web_client.expects(:chat_postMessage).with(options).once
    user = new_user
    Aloha::Server.welcome_new_user @client, user.slack_id, user.username
  end

  private
  def setup_client
    @team = stub(name: "Aloha")
    @web_client = mock('web_client')
    @client = stub(web_client: @web_client, team: @team)
  end

end
