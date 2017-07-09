class AddTeamToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :team_id, :integer
    add_index :messages, :team_id
  end
end
