class AddKindenglishToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :kind_english, :string
  end
end
