class Message < ActiveRecord::Base
  belongs_to :team
  has_many :deliveries
  scope :for_users, -> { where(admin_only: false) }

  before_save :set_delay

  def deliver! client, user
    if user.ready_for?(self) && !user.received?(self)
      Aloha::Server.say(client, user.username, self.content)
      Delivery.where(message: self, user: user).first_or_create!
    end
  end

  private
  def set_delay
    delay_string = "#{self.delay_value} #{self.delay_type}"
    self.delay = ChronicDuration.parse(delay_string).to_i
  end
end