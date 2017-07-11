class ChangeDelayToInteger < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :delay
    add_column :messages, :delay, :integer, default: 0
    add_index :messages, :delay
  end
end
