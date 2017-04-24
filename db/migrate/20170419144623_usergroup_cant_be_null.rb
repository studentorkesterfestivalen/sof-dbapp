class UsergroupCantBeNull < ActiveRecord::Migration[5.0]


  # Make sure no null value exist
  User.update_all usergroup: 0

  def change
    change_column :users, :usergroup, :integer, null: false
  end
end
