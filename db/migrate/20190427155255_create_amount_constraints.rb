class CreateAmountConstraints < ActiveRecord::Migration[5.0]
  def change
    create_table :amount_constraints do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
