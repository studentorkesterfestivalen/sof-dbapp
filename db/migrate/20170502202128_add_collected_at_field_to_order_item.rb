class AddCollectedAtFieldToOrderItem < ActiveRecord::Migration[5.0]
  def change
    change_table :order_items do |t|
      t.datetime :collected_at
    end
  end
end
