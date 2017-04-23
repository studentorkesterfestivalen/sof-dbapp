class AddCostToOrderItem < ActiveRecord::Migration[5.0]
  def change
    change_table :order_items do |t|
      t.integer :cost, default: 0, null: false
    end
  end
end
