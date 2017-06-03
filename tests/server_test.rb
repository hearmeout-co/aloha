require File.expand_path '../test_helper.rb', __FILE__

class ServerTest < AlohaTest
  def setup
    super
    Aloha::Server.load_messages!
  end

  test 'server creates messages in database on load' do
    assert(Message.count > 0)
  end

  test 'server loads messages with data from main config file' do
    assert(Message.where(label: "basics").exists?)
  end

  test 'server reports that user is initialized if a record exists with its username' do
    assert !Aloha::Server.initialized?('ben')
    user = new_user
    assert Aloha::Server.initialized?('ben')
  end

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
