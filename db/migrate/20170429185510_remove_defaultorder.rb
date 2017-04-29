class RemoveDefaultorder < ActiveRecord::Migration[5.0]
  def change
    remove_column :cortege_lineups, :order, :integer, default: 1
    add_column :cortege_lineups, :order, :integer
  end
end
