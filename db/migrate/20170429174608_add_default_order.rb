class AddDefaultOrder < ActiveRecord::Migration[5.0]
  def change
    change_column :cortege_lineups, :order, :integer, default: 1
  end
end
