class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :message
      t.string :label, index: true
      t.string :delay
      t.timestamps
    end
  end
end
