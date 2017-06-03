ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require "minitest/osx"
require 'rack/test'
require "mocha/mini_test"

require File.expand_path '../../app.rb', __FILE__

require 'database_cleaner'

require File.expand_path '../base.rb', __FILE__

DatabaseCleaner.strategy = :truncation

