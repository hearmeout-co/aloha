require 'chronic'

class User < ActiveRecord::Base
  has_many :deliveries

  def ready_for?(message)
    return true if message.delay.blank?
    time_with_delay = Chronic.parse(message.delay + " ago")
    self.created_at < time_with_delay
  end

  def received?(message)
    Delivery.where(user: self, message: message).exists?
  end
end