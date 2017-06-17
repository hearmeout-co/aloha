require File.expand_path '../test_helper.rb', __FILE__

class ControllerTest < AlohaTest
  def setup
    super
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    @controller = Aloha::Controller.new(model, view)

    user = stub(name: new_user.username, id: new_user.slack_id)
    client.stubs(:users).returns(new_user.slack_id => user)
    client.stubs(:team).returns(stub(name: 'Aloha'))

    Aloha::Server.stubs(:say)
    @controller.use_args client, stub(user: new_user.slack_id), nil

    @load_messages = Aloha::Hooks::LoadMessages.new
    Aloha::Hooks::LoadMessages.stubs(:new).returns(@load_messages)
  end

  test 'it welcomes existing users with no record who enter the "join" command' do
    user = stub(name: "someuser", id: "00000000")
    client.stubs(:users).returns(new_user.slack_id => user)
    hook = Aloha::Hooks::WelcomeNewUser.new
    Aloha::Hooks::WelcomeNewUser.expects(:new).returns(hook)
    hook.expects(:call)
    @controller.join
  end

  test 'it does not welcome existing users with a record who enter the "join" command' do
    Aloha::Hooks::WelcomeNewUser.expects(:new).never
    @controller.join
  end

  test 'it outputs an error message to existing users with a record who enter the "join" command' do
    Aloha::Server.expects(:say).with(client, new_user.username, "It looks like you've already joined! You'll hear from me eventually.")
    @controller.join
  end

  test 'it reloads messages on refresh' do
    @load_messages.expects(:call).once
    @controller.refresh
  end

  test 'it confirms messages have been reloaded on refresh' do
    @load_messages.stubs(:call)
    Aloha::Server.expects(:say).with(client, new_user.username, "Refreshed! There are #{Message.count} total messages.")
    @controller.refresh
  end
end
