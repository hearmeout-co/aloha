class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.string :label, index: true
      t.string :delay
      t.timestamps
    end
  end
end
