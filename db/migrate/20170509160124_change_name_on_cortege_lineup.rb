class ChangeNameOnCortegeLineup < ActiveRecord::Migration[5.0]
  def change

    rename_table :cortege_lineups, :lineups

  end
end
