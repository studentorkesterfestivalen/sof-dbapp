class AddPermissionsToMenuItem < ActiveRecord::Migration[5.0]
  def change
    change_table :menu_items do |t|
      t.integer :required_permissions, default: 0, null: false
    end
  end
end
