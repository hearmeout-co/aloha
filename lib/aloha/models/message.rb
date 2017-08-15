class Message < ActiveRecord::Base
  class IncorrectTeamException < Exception; end
  
  belongs_to :team
  has_many :deliveries
  scope :for_users, -> { where(admin_only: false) }

  before_save :set_delay

  def deliver! client, user
    if user.team != self.team
      raise IncorrectTeamException.new("Tried to send a message (#{self.id}) from team #{self.team.id} to a user on team #{user.team.id}")
    end

    if user.should_receive?(self) && user.ready_for?(self) && !user.received?(self)
      Delivery.where(message: self, user: user).first_or_create! do |delivery|
        delivery.client = client
      end
    end
  end

  private
  def set_delay
    delay_string = "#{self.delay_value} #{self.delay_type}"
    self.delay = ChronicDuration.parse(delay_string).to_i
  end
end