class AddUserPermissionMap < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      # Support up to 64 different permissions
      t.integer :permissions, limit: 8
    end
  end
end
