class AddUniqIndexToPort < ActiveRecord::Migration[7.1]
  def change
    add_index :ports, :name, unique: true
  end
end
