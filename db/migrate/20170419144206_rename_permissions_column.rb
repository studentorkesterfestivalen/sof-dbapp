class RenamePermissionsColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :permission, :admin_permissions
  end
end
