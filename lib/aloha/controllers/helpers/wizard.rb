module Aloha
  class Web < Sinatra::Base
    helpers do
      def redirect_to_next_step
        if params[:step] == WIZARD_STEPS.length
          save_blank_slate
          redirect '/messages'
        else
          redirect "/wizard/#{params[:step].to_i + 1}"
        end
      end

      def save_blank_slate
        create_intro_and_coc_message
      end

      def create_intro_and_coc_message
        text = ""
        if session[:wizard][:intros]
          text += <<EOF
"Go ahead and *introduce yourself in the #introductions channel* so we can all get to know who you are! Consider answering:

- What’s your background?
- What kind of work do you do?
- How did you hear of the Slack community?
- What do you hope to get out of our community?"
EOF
        end
        if session[:wizard][:coc_link]
          text += "\n\n" if text.length > 0
          text += "All participants in the #{current_user.team.name} Slack are required to comply with the following code of conduct: #{params[:coc_link]}"
        end

        if text.length > 0
          message = Message.create!(team: current_user.team, content: text)
        end
      end
    end
  end
end