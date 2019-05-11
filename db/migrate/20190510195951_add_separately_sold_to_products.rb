class AddSeparatelySoldToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :separately_sold, :int, default: 0
  end
end
