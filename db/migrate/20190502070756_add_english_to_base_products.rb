class AddEnglishToBaseProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :base_products, :name_english, :string
    add_column :base_products, :description_english, :string
  end
end
