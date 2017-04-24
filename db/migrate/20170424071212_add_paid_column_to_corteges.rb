class AddPaidColumnToCorteges < ActiveRecord::Migration[5.0]
  def change
    add_column :corteges, :paid, :boolean, :default => false, :null => false
  end
end
