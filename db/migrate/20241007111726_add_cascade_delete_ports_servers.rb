class AddCascadeDeletePortsServers < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :ports, :servers
    add_foreign_key :ports, :servers, on_delete: :cascade
  end
end
