class AddRefundedToOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_column :order_items, :refunded, :bool, :default=> false
  end
end
