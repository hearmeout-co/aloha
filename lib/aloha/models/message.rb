class Message < ActiveRecord::Base
  has_many :deliveries
end