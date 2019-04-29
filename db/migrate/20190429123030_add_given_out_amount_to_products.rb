class AddGivenOutAmountToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :given_out_amount, :integer, :default => 0
  end
end
