class User < ActiveRecord::Base
  belongs_to :team
  has_many :deliveries
  validates :username, presence: true
  validates :slack_id, presence: true

  def ready_for?(message)
    return true if message.delay.blank?
    self.created_at + message.delay < Time.now
  end

  def should_receive?(message)
    return message.admin_only == self.is_admin
  end

  def received?(message)
    Delivery.where(user: self, message: message).exists?
  end

  def self.find_create_or_update_by_slack_id!(client, slack_id, team=nil)
    team ||= client.owner
    instance = User.where(team: team, slack_id: slack_id).first
    instance_info = Hashie::Mash.new(client.web_client.users_info(user: slack_id)).user
    instance.update_attributes!(username: instance_info.name) if instance && instance.username != instance_info.name
    instance ||= User.create!(team: team, slack_id: slack_id, username: instance_info.name)
    instance
  end
end