class ChangeBooleansToDefaultFalse < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :is_admin, :boolean, null: false, default: false
    change_column :messages, :admin_only, :boolean, null: false, default: false
  end
end
