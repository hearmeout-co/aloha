require 'aloha/controllers/index'

module Aloha
  class Web < Sinatra::Base
    set :views, Proc.new { File.join(ENV['ROOT_FOLDER'], "lib", "aloha", "views") }
    set :public_folder, Proc.new { File.join(ENV['ROOT_FOLDER'], "public") }
  end
end