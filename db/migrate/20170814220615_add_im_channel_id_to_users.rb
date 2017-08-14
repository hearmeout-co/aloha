class AddImChannelIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :im_channel_id, :string
  end
end
