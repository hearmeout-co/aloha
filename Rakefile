require './app'
require 'sinatra/activerecord/rake'

require "rake/testtask"

Rake::TestTask.new do |t|
  t.test_files = FileList['tests/**/*_test.rb']
  t.warning = false
end
desc "Run tests"
