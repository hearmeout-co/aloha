require 'sinatra/base'

module Aloha
  class Web < Sinatra::Base
    get '/' do
      'Running successfully.'
    end
  end
end
