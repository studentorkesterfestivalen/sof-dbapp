class CreateShoppingItems < ActiveRecord::Migration[5.0]
  def change
    create_table :shopping_items do |t|
      t.integer :cost
      t.text :name
      t.text :data
      t.string :type
      t.belongs_to :shopping_order, index: true

      t.timestamps
    end
  end
end
