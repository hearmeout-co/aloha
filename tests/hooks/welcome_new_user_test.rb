require File.expand_path '../../test_helper.rb', __FILE__

class WelcomeNewUserTest < AlohaTest
  def setup
    super
    user = stub(name: 'ben', id: 'U024BE7LH')
    client.stubs(:users).returns('U024BE7LH' => user)
    client.stubs(:team).returns(stub(name: 'Aloha'))
    client.web_client.stubs(:chat_postMessage)
    @data = stub(user: 'U024BE7LH')
    Message.create!(content: 'This is a welcome message', label: 'welcome')
  end

  test 'it welcomes new users with the team name' do
    options = { text: "Welcome to Aloha!", channel: "@ben", as_user: true, link_names: true }
    client.web_client.expects(:chat_postMessage).with(options).once
    Aloha::Hooks::WelcomeNewUser.new.call(client, @data)
  end

  test 'it welcomes new users with messages that have no delay' do
    text = 'This is a welcome message'
    options = { text: text, channel: "@ben", as_user: true, link_names: true }
    client.web_client.expects(:chat_postMessage).with(options).once
    Aloha::Hooks::WelcomeNewUser.new.call(client, @data)
  end
end