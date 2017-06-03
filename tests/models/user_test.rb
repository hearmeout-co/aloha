require File.expand_path '../../test_helper.rb', __FILE__

class UserTest < AlohaTest
  test 'user is valid with a username and slack_id' do
    user = User.new(username: 'ben', slack_id: 'U024BE7LH')
    assert user.valid?
  end
  test 'user is valid with no username' do
    user = User.new(username: nil, slack_id: 'U024BE7LH')
    assert !user.valid?
  end
  test 'user is valid with no slack_id' do
    user = User.new(username: 'ben', slack_id: nil)
    assert !user.valid?
  end
end
