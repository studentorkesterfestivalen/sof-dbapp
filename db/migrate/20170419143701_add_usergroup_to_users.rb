class AddUsergroupToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :usergroup, :integer, limit: 8
  end
end
