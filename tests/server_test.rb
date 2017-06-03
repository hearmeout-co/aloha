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
    user = User.create!(username: 'ben', slack_id: 'U024BE7LH')
    assert Aloha::Server.initialized?('ben')
  end
end
