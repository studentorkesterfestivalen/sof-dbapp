class CreateShoppingCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :shopping_carts do |t|
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
