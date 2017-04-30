class AddRebateBalanceToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :rebate_balance, :integer, :default => 0
    add_column :users, :rebate_given, :boolean, :defaul => false
  end
end
