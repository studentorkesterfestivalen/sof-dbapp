class BaseProductHasImage < ActiveRecord::Migration[5.0]
  def change
    add_column :base_products, :has_image, :boolean, default: false, null: false
    add_column :base_products, :image_path, :string, default: '', null: false
  end
end
