class OrderItemsUseAmount < ActiveRecord::Migration[5.0]
  def up
    add_column :order_items, :amount, :integer 
  end
  def down
    remove_column :order_items, :amount
  end
end
