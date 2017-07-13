require 'aloha/presenters/message_presenter'
require 'cgi'

module Aloha
  class Web < Sinatra::Base
    helpers { include Aloha::Presenters::MessagePresenter }
    
    get '/app/messages' do
      @message_groups = Message.for_users
        .where(team: current_user.team)
        .order(:delay)
        .group_by(&:delay)
      erb :'app/messages/index'
    end

    get '/app/messages/new' do
      @message = Message.new
      erb :'app/messages/edit'
    end

    get '/app/messages/:id' do
      @message = Message.where(team: current_user.team).find(params[:id])
      erb :'app/messages/edit'
    end

    post '/app/messages/:id' do
      create_or_update_message
    end

    delete '/app/messages/:id' do
      @message = Message.where(team: current_user.team).find(params[:id])
      @message.destroy!
      redirect '/app/messages'
    end
    
    post '/app/messages' do
      create_or_update_message
    end

    helpers do
      def create_or_update_message
        if params[:id]
          @message = Message.where(team: current_user.team).find(params[:id])
        else
          @message = Message.new
        end
        @message.content = CGI.unescapeHTML(params[:content])
        @message.delay_value = params[:delay_value]
        @message.delay_type = params[:delay_type]
        @message.team = current_user.team
        @message.save!
        redirect '/app/messages'
      end
    end
  end
end