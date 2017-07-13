module Aloha
  class Web < Sinatra::Base
    helpers do
      def redirect_to_next_step
        if params[:step].to_i >= WIZARD_STEPS.length
          save_blank_slate
          redirect '/app/messages'
        else
          redirect "/wizard/#{params[:step].to_i + 1}"
        end
      end

      def save_blank_slate
        create_intro_message
        create_coc_message
        create_wiki_message
        create_guidance_message
        create_interruptions_message
      end

      def create_intro_message
        if session[:wizard][:intros].to_s.length > 0
          channel_name = session[:wizard][:intros].sub(/^#/, '')
          text = "Go ahead and *introduce yourself in the `##{channel_name}` channel* so we can all get to know who you are! Consider answering:

- What’s your background?
- What kind of work do you do?
- How did you hear of the Slack community?
- What do you hope to get out of our community?"
        end
        if text.length > 0
          message = Message.create!(team: current_user.team, content: text)
        end
      end

      def create_coc_message
        if session[:wizard][:coc_link].to_s.length > 0
          text = "All participants in the #{current_user.team.name} Slack are required to comply with the following code of conduct: #{session[:wizard][:coc_link]}"
          message = Message.create!(team: current_user.team, content: text)
        end

      end

      def create_wiki_message
        if session[:wizard][:wiki_link].to_s.length > 0
          text = "Here's a link to some docs that will help you get started: #{session[:wizard][:wiki_link]}"
          message = Message.create!(team: current_user.team, content: text, delay_value: 15, delay_type: "minutes")
        end
      end

      def create_guidance_message
        if session[:wizard][:guidance].to_s.length > 0
          text = session[:wizard][:guidance]
          message = Message.create!(team: current_user.team, content: text, delay_value: 1, delay_type: "hours")
        end
      end

      def create_interruptions_message
        if session[:wizard][:interruptions] == "on"
          text = "We do our best to cut down on interruptions:

- Please avoid using `@channel` mentions whenever possible (you can use `@here` instead to notify desktop users).
- If you need someone's attention, it's usually better to *mention them in a public channel* instead of sending a private message whenever possible."
          message = Message.create!(team: current_user.team, content: text, delay_value: 1, delay_type: "hours")
        end
      end
    end
  end
end