class AddIndexToDeliveriesForMessageAndUserId < ActiveRecord::Migration[5.0]
  def change
    add_index :deliveries, [:message_id, :user_id]
  end
end
