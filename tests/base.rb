class AlohaTest < ActiveSupport::TestCase
  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def new_user
    @new_user ||= User.create!(username: 'ben', slack_id: 'U024BE7LH')
  end
end