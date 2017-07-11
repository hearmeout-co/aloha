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

    post '/wizard/next' do
      [:intros, :coc_link, :wiki_link, :guidance, :interruptions].each do |step_name|
        session[:wizard][step_name] = params[step_name] if params[step_name]
      end
      redirect_to_next_step
    end
  end
end