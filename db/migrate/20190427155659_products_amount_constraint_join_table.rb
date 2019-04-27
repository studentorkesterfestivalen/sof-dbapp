class ProductsAmountConstraintJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :products, :amount_constraints do |t|
      t.index :product_id
      t.index :amount_constraint_id
    end
  end
end
