require File.expand_path '../../test_helper.rb', __FILE__

class CheckForUpdatesTest < AlohaTest
  def setup
    super
    user = stub(name: 'ben', id: 'U024BE7LH')
    client.stubs(:users).returns('U024BE7LH' => user)
    client.stubs(:team).returns(stub(name: 'Aloha'))
    client.web_client.stubs(:chat_postMessage)
    @admin_username = "ben"
    @user = new_user
    @user.update_attributes! is_admin: true
    @current_version_json = File.open(File.join($ROOT_FOLDER, "config", "version.json")).read
    @data = stub(user: 'U024BE7LH', presence: 'active')
  end

  test 'it checks for updates when an admin becomes active' do
    HTTP.expects(:get).returns(@current_version_json)
    Aloha::Hooks::CheckForUpdates.new.call(client, @data)
  end

  test 'it does not check for updates when a non-admin becomes active' do
    @user.update_attributes! is_admin: false
    HTTP.expects(:get).never
    Aloha::Hooks::CheckForUpdates.new.call(client, @data)
  end

  test 'it creates an update message when the current version is less than the latest version' do
    assert !Message.where(label: "aloha-system-update-v-100.0.0").exists?
    HTTP.expects(:get).returns('{"version": "100.0.0"}')
    Aloha::Hooks::CheckForUpdates.new.call(client, @data)
    assert Message.where(label: "aloha-system-update-v-100.0.0").exists?
  end

  test 'it creates update messages that are marked as admin_only' do
    HTTP.expects(:get).returns('{"version": "100.0.0"}')
    Aloha::Hooks::CheckForUpdates.new.call(client, @data)
    assert Message.find_by(label: "aloha-system-update-v-100.0.0").admin_only?
  end

  test 'it creates update messages that include the version in the content' do
    HTTP.expects(:get).returns('{"version": "100.0.0"}')
    Aloha::Hooks::CheckForUpdates.new.call(client, @data)
    assert Message.find_by(label: "aloha-system-update-v-100.0.0").content.include?("version 100.0.0")
  end

end