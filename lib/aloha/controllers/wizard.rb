module Aloha
  class Web < Sinatra::Base
    WIZARD_STEPS = ['intros', 'coc', 'wiki', 'guidance', 'interruptions']
    get '/wizard/?' do
      redirect '/wizard/1'
    end

    get '/wizard/:step/?' do
      erb "wizard/#{WIZARD_STEPS[params[:step].to_i - 1]}".to_sym
    end

    post '/wizard/intros' do
      session[:wizard] ||= {}
      session[:wizard][:intros_channel_name] = params[:channel_name]
      redirect "/wizard/#{params[:step].to_i + 1}"
    end
  end
end