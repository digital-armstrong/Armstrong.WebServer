class CreatePorts < ActiveRecord::Migration[7.1]
  def change
    create_table :ports do |t|
      t.string :name
      t.integer :rate
      t.belongs_to :server, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
