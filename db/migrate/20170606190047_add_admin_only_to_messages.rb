class AddAdminOnlyToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :admin_only, :boolean
  end
end
