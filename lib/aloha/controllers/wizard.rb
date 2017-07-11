module Aloha
  class Web < Sinatra::Base
    WIZARD_STEPS = ['intros', 'coc', 'wiki', 'guidance', 'interruptions']

    before Regexp.new("\/wizard\/.+") do
      session[:wizard] ||= {}
    end

    get '/wizard/?' do
      redirect '/wizard/1'
    end

    get '/wizard/:step/?' do
      @is_last_step = params[:step].to_i >= WIZARD_STEPS.length
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