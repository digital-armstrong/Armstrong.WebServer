class AddIndexToServerName < ActiveRecord::Migration[7.1]
  def change
    add_index :servers, :name
  end
end
