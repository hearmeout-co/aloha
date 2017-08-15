class Delivery < ActiveRecord::Base
  attr_accessor :client

  belongs_to :message
  belongs_to :user

  before_create :send_slack_message

  def client
    @client ||= Slack::RealTime::Client.new(token: self.user.team.token)
  end

  private
  def send_slack_message
    client.web_client.chat_postMessage(text: self.message.content, channel: self.user.im_channel_id, link_names: true)
  end
end