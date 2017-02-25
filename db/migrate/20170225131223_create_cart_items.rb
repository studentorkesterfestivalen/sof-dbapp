class CreateCartItems < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_items do |t|
      t.string :object_type, null: false
      t.string :object_name, null: false
      t.text :data

      t.belongs_to :shopping_cart, index: true

      t.timestamps
    end
  end
end
