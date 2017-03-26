class CreateFunkisCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :funkis_categories do |t|
      t.string :name, null: false
      t.string :funkis_name, null: false
      t.string :description, null: false
      t.string :points, null: false

      t.timestamps
    end
  end
end
