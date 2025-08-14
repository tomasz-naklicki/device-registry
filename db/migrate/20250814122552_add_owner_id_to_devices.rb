class AddOwnerIdToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :owner_id, :integer
    add_index  :devices, :owner_id
    add_foreign_key :devices, :users, column: :owner_id
  end
end
