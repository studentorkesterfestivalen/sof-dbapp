class CreateDiscountCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :discount_codes do |t|
      t.integer :discount
      t.integer :uses
      t.string :code, null: false
      t.references :product, foreign_key: true

      t.timestamps
    end

    add_column :carts, :discount_code_id, :integer

    add_column :orders, :discount_code_id, :integer
  end
end
