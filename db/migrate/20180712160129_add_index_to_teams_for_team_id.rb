class AddIndexToTeamsForTeamId < ActiveRecord::Migration[5.0]
  def change
    add_index :teams, :team_id
  end
end
