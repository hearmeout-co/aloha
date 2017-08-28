class Team < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :deliveries, through: :messages
end