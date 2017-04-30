class AddGroupPermissionsToBaseProduct < ActiveRecord::Migration[5.0]
  def change
    change_table :base_products do |t|
      t.integer :required_group_permissions, limit: 8, default: 0, null: false
    end
  end
end
