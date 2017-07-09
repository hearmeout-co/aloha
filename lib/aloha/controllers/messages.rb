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

    get '/messages/new' do
      @message = Message.new
      erb :'messages/edit'
    end

    get '/messages/:id/edit' do
      @message = Message.where(team: current_user.team).find(params[:id])
      erb :'messages/edit'
    end

    post '/messages' do
      if params[:id]
        @message = Message.where(team: current_user.team).find(params[:id])
      else
        @message = Message.new
      end
      @message.content = params[:content]
      delay = "#{params[:delay_value]} #{params[:delay_type]}"
      @message.delay = ChronicDuration.parse(delay)
      @message.team = current_user.team
      @message.save!
      redirect '/messages'
    end
  end
end