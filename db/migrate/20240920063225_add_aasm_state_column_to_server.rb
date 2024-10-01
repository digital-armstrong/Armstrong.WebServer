class AddAasmStateColumnToServer < ActiveRecord::Migration[7.1]
  def change
    add_column :servers, :aasm_state, :string, default: 'idle'
  end
end
