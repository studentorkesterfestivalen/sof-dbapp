class UsergroupCantBeNull < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :usergroup, :integer, null: false
  end
end
