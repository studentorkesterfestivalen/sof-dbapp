class AddCollectedFieldToOrderItem < ActiveRecord::Migration[5.0]
  def change
    change_table :order_items do |t|
      t.boolean :collected, default: false, null: false
    end
  end
end
