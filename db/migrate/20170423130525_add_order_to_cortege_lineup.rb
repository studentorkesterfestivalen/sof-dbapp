class AddOrderToCortegeLineup < ActiveRecord::Migration[5.0]
  def change
    add_column :cortege_lineups, :order, :integer
  end
end
