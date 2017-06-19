require File.expand_path '../../test_helper.rb', __FILE__

class LoadMessagesTest < AlohaTest
  def setup
    super
    Aloha::Hooks::LoadMessages.new.call(nil, nil)
  end

  test 'server creates messages in database on load' do
    assert(Message.count > 0)
  end

  test 'server loads messages with data from main config file' do
    assert(Message.where(label: "basics").exists?)
  end

  test 'server sets content on messages with data from main config file' do
    assert(!Message.find_by(label: "basics").content.empty?)
  end
end