class CreateDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :deliveries do |t|
      t.integer :user_id, index: true
      t.integer :message_id, index: true
      t.timestamps
    end

  end
end
