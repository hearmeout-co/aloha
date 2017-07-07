require 'chronic'

class User < ActiveRecord::Base
  belongs_to :team
  has_many :deliveries
  validates :username, presence: true
  validates :slack_id, presence: true

  def ready_for?(message)
    return true if message.delay.blank?
    time_with_delay = Chronic.parse(message.delay + " ago")
    self.created_at < time_with_delay
  end

  def received?(message)
    Delivery.where(user: self, message: message).exists?
  end

  def self.find_create_or_update_by_slack_id!(client, slack_id)
    instance = User.where(team: client.owner, slack_id: slack_id).first
    instance_info = Hashie::Mash.new(client.web_client.users_info(user: slack_id)).user
    instance.update_attributes!(username: instance_info.name) if instance && instance.username != instance_info.name
    instance ||= User.create!(team: client.owner, slack_id: slack_id, username: instance_info.name)
    instance
  end
end