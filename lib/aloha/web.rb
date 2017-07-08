require 'aloha/controllers/index'
require 'aloha/controllers/install'
require 'aloha/controllers/welcome'
require 'aloha/controllers/login'

module Aloha
  class Web < Sinatra::Base
    set :views, Proc.new { File.join(ENV['ROOT_FOLDER'], "lib", "aloha", "views") }
    set :public_folder, Proc.new { File.join(ENV['ROOT_FOLDER'], "public") }
  end
end