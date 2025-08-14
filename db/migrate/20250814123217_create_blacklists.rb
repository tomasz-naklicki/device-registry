class CreateBlacklists < ActiveRecord::Migration[7.1]
  def change
    create_table :blacklists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end

    add_index :blacklists, [:user_id, :device_id], unique: true
  end
end
