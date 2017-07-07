require 'aloha/controllers/index'
require 'aloha/controllers/configure'
require 'aloha/controllers/deploy'

module Aloha
  class Web < Sinatra::Base
    set :views, Proc.new { File.join(ENV['ROOT_FOLDER'], "lib", "aloha", "views") }
    set :public, Proc.new { File.join(ENV['ROOT_FOLDER'], "public") }
  end
end