class ChangeTypeCortegeLineups < ActiveRecord::Migration[5.0]
  def change
    remove_column :cortege_lineups, :type, :string
    add_column :cortege_lineups, :cortege_type, :string
  end
end
