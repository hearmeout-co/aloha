class AddDelayTypeAndDelayValueToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :delay_value, :integer, null: false, default: 0
    add_column :messages, :delay_type, :string, null: false, default: 'minutes'
  end
end
