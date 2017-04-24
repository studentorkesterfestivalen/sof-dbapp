class AddGiftableFieldToProduct < ActiveRecord::Migration[5.0]
  def change
    change_table :base_products do |t|
      t.boolean :giftable, default: false, null: false
    end
  end
end
