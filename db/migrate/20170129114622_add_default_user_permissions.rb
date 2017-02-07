class AddDefaultUserPermissions < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :permissions, :integer, default: 0, null: false
  end
end
