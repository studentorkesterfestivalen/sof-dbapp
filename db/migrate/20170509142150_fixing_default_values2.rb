class FixingDefaultValues2 < ActiveRecord::Migration[5.0]
  def change

    remove_column :cortege_lineups, :orchestra, :boolean, default: false, null: false
    remove_column :cortege_lineups, :ballet, :boolean, default: false, null: false
    remove_column :cortege_lineups, :cortege, :boolean, default: false, null: false

  end
end
