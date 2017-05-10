class FixedDefaultValues3 < ActiveRecord::Migration[5.0]
  def change

    add_column :cortege_lineups, :orchestra, :boolean
    add_column :cortege_lineups, :ballet, :boolean
    add_column :cortege_lineups, :cortege, :boolean

  end
end
