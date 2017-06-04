require File.expand_path '../../test_helper.rb', __FILE__

class WelcomeNewUserTest < AlohaTest
  def setup
    super
    user = stub(name: 'ben', id: 'U024BE7LH')
    client.stubs(:users).returns('U024BE7LH' => user)
    client.stubs(:team).returns(stub(name: 'Aloha'))
    client.web_client.expects(:chat_postMessage).at_least_once
    @data = stub(user: 'U024BE7LH')
    Aloha::Hooks::LoadMessages.new.call(client, nil)
  end

  test 'it welcomes new users with the team name' do
    options = { text: "Welcome to Aloha!", channel: "@ben", as_user: true, link_names: true }
    client.web_client.expects(:chat_postMessage).with(options).once
    Aloha::Hooks::WelcomeNewUser.new.call(client, @data)
  end

  test 'it welcomes new users with messages that have no delay' do
    text = "Go ahead and *introduce yourself in the #introductions channel* so we can all get to know who you are! Consider answering:\n\n- What’s your background?\n- What kind of work do you do?\n- How did you hear of the Slack community?\n- What do you hope to get out of our community?"
    options = { text: text, channel: "@ben", as_user: true, link_names: true }
    client.web_client.expects(:chat_postMessage).with(options).once
    Aloha::Hooks::WelcomeNewUser.new.call(client, @data)
  end
end