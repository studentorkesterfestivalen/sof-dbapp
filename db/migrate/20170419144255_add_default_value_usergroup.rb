class AddDefaultValueUsergroup < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :usergroup, :integer, default: 0
  end
end
