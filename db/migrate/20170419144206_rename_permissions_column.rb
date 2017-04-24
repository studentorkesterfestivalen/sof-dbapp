class RenamePermissionsColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :permissions, :admin_permissions
  end
end
