class AddValidThroughToCart < ActiveRecord::Migration[5.0]
  def change
    add_column :carts, :valid_through, :datetime 
  end
end
