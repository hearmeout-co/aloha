require File.expand_path '../../test_helper.rb', __FILE__

class SetupAdminUserTest < AlohaTest
  def setup
    super
    user = stub(name: 'ben', id: 'U024BE7LH')
    client.stubs(:users).returns('U024BE7LH' => user)
    client.stubs(:team).returns(stub(name: 'Aloha'))
    client.web_client.stubs(:chat_postMessage)
    @admin_username = "ben"
    assert !User.where(username: @admin_username).exists?
    ENV['ADMIN_USERNAME'] = @admin_username
    @data = stub(user: 'U024BE7LH', presence: 'active')
  end

  test 'it creates a new user with the admin username' do
    Aloha::Hooks::SetupAdminUser.new.call(client, @data)
    assert User.where(username: @admin_username).exists?
  end

  test 'it assigns admin permissions to the new admin user' do
    Aloha::Hooks::SetupAdminUser.new.call(client, @data)
    assert User.find_by(username: @admin_username).is_admin?
  end

  test 'it says hello to the new admin user' do
    client.web_client.expects(:chat_postMessage)
    Aloha::Hooks::SetupAdminUser.new.call(client, @data)
  end
end