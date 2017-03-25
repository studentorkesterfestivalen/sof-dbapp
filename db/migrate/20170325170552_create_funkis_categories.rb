class CreateFunkisCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :funkis_categories do |t|
      t.string :name, null: false
      t.string :name_clarification, null: false
      t.name :description, null: false
      t.string :points, null: false

      t.timestamps
    end
  end
end
