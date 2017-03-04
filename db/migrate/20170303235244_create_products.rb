class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :type, null: true
      t.integer :cost, null: true
      t.boolean :enabled, default: true, null: false

      t.belongs_to :base_product, index: true

      t.timestamps
    end
  end
end
