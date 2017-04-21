class AddOwnerToOrderItem < ActiveRecord::Migration[5.0]
  def change
    add_reference :order_items, :owner, foreign_key: {to_table: :users}
  end
end
