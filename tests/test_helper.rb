ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require "minitest/osx"
require 'rack/test'
require "mocha/mini_test"

require File.expand_path '../../app.rb', __FILE__

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

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

  def client
    server.send(:client)
  end

  def server
    @server ||= Aloha::Server.new
  end

  def new_message
    @new_message ||= Message.create!(content: 'This is a welcome message', label: 'welcome')
  end
end