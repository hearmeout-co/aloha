ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require "minitest/osx"
require 'rack/test'

require File.expand_path '../../app.rb', __FILE__

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

