class AddUnionMembershipToUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :union, default: nil
      t.datetime :union_valid_thru, default: DateTime.now, null: false
    end
  end
end
