class CreateShoppingProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :shopping_products do |t|
      t.string :name
      t.text :description
      t.integer :cost
      t.text :options

      t.timestamps
    end
  end
end
