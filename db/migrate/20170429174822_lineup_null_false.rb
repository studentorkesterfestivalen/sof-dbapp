class LineupNullFalse < ActiveRecord::Migration[5.0]
  def change

    change_column :cortege_lineups, :name, :string, null: false
    change_column :cortege_lineups, :description, :text, null: false
    change_column :cortege_lineups, :image, :string, null: false


  end
end
