class CartItemsUseAmount < ActiveRecord::Migration[5.0]
  def up
    add_column :cart_items, :amount, :integer, :default => 0
  end
  def down
    remove_column :cart_items, :amount
  end
end
