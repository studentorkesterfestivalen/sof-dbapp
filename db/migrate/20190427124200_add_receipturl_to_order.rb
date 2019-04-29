class AddReceipturlToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :receipt_url, :string
  end
end
