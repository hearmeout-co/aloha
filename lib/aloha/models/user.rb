class User < ActiveRecord::Base
  has_many :deliveries
end