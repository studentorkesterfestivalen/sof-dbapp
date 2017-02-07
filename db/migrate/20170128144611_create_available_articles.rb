class CreateAvailableArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :available_articles do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.string :data_name
      t.text :data_description
      t.boolean :orchestra_only
      t.boolean :enabled

      t.timestamps
    end
  end
end
