class Delivery < ActiveRecord::Base
  include Aloha::LoggedModel
  
  attr_accessor :client

  belongs_to :message
  belongs_to :user

  before_create :send_slack_message
  after_create :send_to_analytics

  def client
    @client ||= Slack::RealTime::Client.new(token: self.user.team.token)
  end

  private
  def send_slack_message
    link_names = self.message.content.match(/@(channel|here|everyone)/) ? 0 : 1
    client.web_client.chat_postMessage(text: self.message.content, channel: self.user.im_channel_id, link_names: link_names)
  end

  def send_to_analytics
    Aloha::Helpers::Analytics.increment('deliveries.total', 1)
  end
end