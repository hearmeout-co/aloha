class Team < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :deliveries, through: :messages

  after_create :send_to_analytics

  private
  def send_to_analytics
    Aloha::Helpers::Analytics.increment('teams.total', 1)
  end
end