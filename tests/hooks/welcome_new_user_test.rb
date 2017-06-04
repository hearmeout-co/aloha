require File.expand_path '../../test_helper.rb', __FILE__

class WelcomeNewUserTest < AlohaTest
  def setup
    super
    user = stub(name: 'ben', id: 'U024BE7LH')
    client.stubs(:users).returns('U024BE7LH' => user)
    client.stubs(:team).returns(stub(name: 'Aloha'))
    Aloha::Hooks::LoadMessages.new.call(client, nil)
  end

  test 'it welcomes new users with the team name' do
    client.web_client.expects(:chat_postMessage).at_least_once
    options = { text: "Welcome to Aloha!", channel: "@ben", as_user: true, link_names: true }
    client.web_client.expects(:chat_postMessage).with(options).once

    data = stub(user: 'U024BE7LH')
    Aloha::Hooks::WelcomeNewUser.new.call(client, data)
  end
end