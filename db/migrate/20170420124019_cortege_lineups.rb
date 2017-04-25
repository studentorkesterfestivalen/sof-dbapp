class CortegeLineups < ActiveRecord::Migration[5.0]
  def change
    change_table :cortege_lineups do |t|
      t.string :type
    end
  end
end
