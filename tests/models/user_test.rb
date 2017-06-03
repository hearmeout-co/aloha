require File.expand_path '../../test_helper.rb', __FILE__

class UserTest < AlohaTest
  test 'valid user' do
    user = User.new(username: 'ben', slack_id: 'U024BE7LH')
    assert user.valid?
  end
end
