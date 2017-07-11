require File.expand_path '../test_helper.rb', __FILE__

class ControllerTest < AlohaTest
  def setup
    super
    user = stub(name: new_user.username, id: new_user.slack_id)
    client.stubs(:users).returns(new_user.slack_id => user)
    client.stubs(:team).returns(stub(name: 'Aloha'))

    Aloha::Server.stubs(:say)
  end

  test 'it welcomes existing users with no record who enter the "join" command' do
    user = stub(name: "someuser", id: "00000000")
    client.stubs(:users).returns(new_user.slack_id => user)
    hook = Aloha::Hooks::WelcomeNewUser.new
    Aloha::Hooks::WelcomeNewUser.expects(:new).returns(hook)
    hook.expects(:call)
    Aloha::Commands::Join.call(client, stub(user: new_user.slack_id), nil)
  end

  test 'it does not welcome existing users with a record who enter the "join" command' do
    Aloha::Hooks::WelcomeNewUser.expects(:new).never
    Aloha::Commands::Join.call(client, stub(user: new_user.slack_id), nil)
  end

  test 'it outputs an error message to existing users with a record who enter the "join" command' do
    Aloha::Server.expects(:say).with(client, new_user.username, "It looks like you've already joined! You'll hear from me eventually.")
    Aloha::Commands::Join.call(client, stub(user: new_user.slack_id), nil)
  end

  test 'it reloads messages on refresh' do
    @load_messages.expects(:call).once
    Aloha::Commands::Refresh.call(client, stub(user: new_user.slack_id), nil)
  end

  test 'it confirms messages have been reloaded on refresh' do
    @load_messages.stubs(:call)
    Aloha::Server.expects(:say).with(client, new_user.username, "Refreshed! There are #{Message.count} total messages.")
    Aloha::Commands::Refresh.call(client, stub(user: new_user.slack_id), nil)
  end
end
