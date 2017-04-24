class AddVariantPurchaseLimit < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.integer :purchase_limit, default: 0, null: false
    end
  end
end
