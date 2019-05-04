class ChangeCollectedToInt < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      change_table :order_items do |t|
        dir.up   {
          change_column_default(:order_items, :collected, nil)
          t.change :collected, 'integer USING collected::integer'
          change_column_default(:order_items, :collected, 0)
        }
        dir.down   { 
          change_column_default(:order_items, :collected, nil)
          t.change :collected, 'bool USING collected::bool'
          change_column_default(:order_items, :collected, false)
        }
      end
    end
  end
end
