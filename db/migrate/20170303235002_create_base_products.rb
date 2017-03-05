class CreateBaseProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :base_products do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :cost, null: true
      t.integer :required_permissions, null: true
      t.boolean :enabled, default: true, null: false

      t.timestamps
    end
  end
end
