class AddAdminOnlyToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :admin_only, :boolean
  end
end
