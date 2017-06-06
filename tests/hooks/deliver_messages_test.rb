require File.expand_path '../../test_helper.rb', __FILE__

class DeliverMessagesTest < AlohaTest
  def setup
    super
    user = stub(name: new_user.username, id: new_user.slack_id)
    client.stubs(:users).returns(new_user.slack_id => user)
    client.stubs(:team).returns(stub(name: 'Aloha'))
    @data = stub(user: new_user.slack_id, presence: 'active')
    Message.create!(content: 'This is a welcome message', label: 'welcome')
    Message.create!(content: 'This is a later message', label: 'welcome', delay: '15 seconds')
    Message.create!(content: 'This is an even later message', label: 'welcome', delay: '30 seconds')
  end

  test 'it delivers all messages with no delay' do
    options = { text: 'This is a welcome message', channel: "@ben", as_user: true, link_names: true }
    client.web_client.expects(:chat_postMessage).with(options)
    Aloha::Hooks::DeliverMessages.new.call(client, @data)    
  end

  test 'it does not deliver any messages with a delay greater than the time since the user was created' do
    client.web_client.expects(:chat_postMessage).once
    Aloha::Hooks::DeliverMessages.new.call(client, @data)
  end

  test 'it does not deliver any messages twice' do
    client.web_client.expects(:chat_postMessage).once
    Aloha::Hooks::DeliverMessages.new.call(client, @data)
    Aloha::Hooks::DeliverMessages.new.call(client, @data)
  end

  test 'it delivers all messages with a delay small than the time since the user was created' do
    options = { text: 'This is a later message', channel: "@ben", as_user: true, link_names: true }
    client.web_client.stubs(:chat_postMessage)
    client.web_client.expects(:chat_postMessage).with(options).once
    new_user.update_column('created_at', Time.now - 29.seconds)
    Aloha::Hooks::DeliverMessages.new.call(client, @data)
  end
end