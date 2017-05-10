class FixingDefaultValues < ActiveRecord::Migration[5.0]
  def change

    change_column_default :cortege_lineups, :orchestra, :nil

  end
end
