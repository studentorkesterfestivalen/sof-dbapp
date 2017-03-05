class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :payment_method, null: false
      t.string :payment_data, null: true

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
