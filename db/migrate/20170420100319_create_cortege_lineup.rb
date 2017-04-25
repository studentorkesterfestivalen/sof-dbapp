class CreateCortegeLineup < ActiveRecord::Migration[5.0]
  def change
    create_table :cortege_lineups do |t|
      t.string :name
      t.text :description
      t.string :image
    end
  end
end
