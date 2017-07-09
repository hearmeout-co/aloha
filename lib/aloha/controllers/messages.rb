require 'aloha/presenters/message_presenter'

module Aloha
  class Web < Sinatra::Base
    helpers { include Aloha::Presenters::MessagePresenter }
    
    before /\/messages\/?.*?/ do
      require_login!
    end

    get '/messages' do
      @message_groups = Message.for_users
        .where(team: current_user.team)
        .order(:delay)
        .group_by(&:delay)
      erb :'messages/index'
    end
  end
end