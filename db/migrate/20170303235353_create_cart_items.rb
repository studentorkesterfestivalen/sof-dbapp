class CreateCartItems < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_items do |t|
      t.belongs_to :cart, index: true
      t.belongs_to :product, index: false

      t.timestamps
    end
  end
end
