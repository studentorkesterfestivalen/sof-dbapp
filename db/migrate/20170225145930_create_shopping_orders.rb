class CreateShoppingOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :shopping_orders do |t|
      t.integer :order_id
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
