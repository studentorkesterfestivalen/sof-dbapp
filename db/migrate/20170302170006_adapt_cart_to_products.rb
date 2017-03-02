class AdaptCartToProducts < ActiveRecord::Migration[5.0]
  def change
    remove_column :cart_items, :object_type
    remove_column :cart_items, :object_name
    add_reference :cart_items, :product, references: :shopping_products, index: true
  end
end
