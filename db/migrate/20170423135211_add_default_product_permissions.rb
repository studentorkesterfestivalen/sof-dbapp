class AddDefaultProductPermissions < ActiveRecord::Migration[5.0]
  def change
    change_column :base_products, :required_permissions, :integer, :limit => 8, :default => 0

    # Ensure no field is null
    BaseProduct.all.each do |product|
      if product.required_permissions.nil?
        product.required_permissions = 0
        product.save
      end
    end

    change_column_null :base_products, :required_permissions, false
  end
end
