class Message < ActiveRecord::Base
  has_many :deliveries

  def deliver! client, user
    if user.ready_for?(self) && !user.received?(self)
      Aloha::Server.say(client, user.username, self.content)
      Delivery.where(message: self, user: user).first_or_create!
    end
  end
end