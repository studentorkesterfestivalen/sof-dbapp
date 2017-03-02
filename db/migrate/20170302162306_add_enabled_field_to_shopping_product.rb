class AddEnabledFieldToShoppingProduct < ActiveRecord::Migration[5.0]
  def change
    change_table :shopping_products do |t|
      t.boolean :enabled, default: true, null: false
    end
  end
end
