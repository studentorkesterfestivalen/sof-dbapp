class AddRebateToOrder < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.integer :rebate, default: 0, null: false
    end
  end
end
