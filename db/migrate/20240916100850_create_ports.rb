class CreatePorts < ActiveRecord::Migration[7.1]
  def change
    create_table :ports do |t|
      t.string :name
      t.integer :rate

      t.timestamps
    end
  end
end
