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
end
