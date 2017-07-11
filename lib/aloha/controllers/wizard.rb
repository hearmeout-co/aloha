module Aloha
  class Web < Sinatra::Base
    before Regexp.new("\/wizard\/.+") do
      session[:wizard] ||= {}
    end

    helpers do
      def redirect_to_next_step
        redirect "/wizard/#{params[:step].to_i + 1}"
      end
    end

    WIZARD_STEPS = ['intros', 'coc', 'wiki', 'guidance', 'interruptions']
    get '/wizard/?' do
      redirect '/wizard/1'
    end

    get '/wizard/:step/?' do
      erb "wizard/#{WIZARD_STEPS[params[:step].to_i - 1]}".to_sym
    end

    post '/wizard/intros' do
      session[:wizard][:intros_channel_name] = params[:channel_name]
      redirect_to_next_step
    end

    post '/wizard/coc' do
      session[:wizard][:coc_link] = params[:coc_link]
      redirect_to_next_step
    end
  end
end