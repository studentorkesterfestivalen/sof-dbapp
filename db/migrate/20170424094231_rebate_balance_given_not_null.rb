class RebateBalanceGivenNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :rebate_given, :boolean, default: false

    #ensure no field is null
    User.all.each do |user|
      if user.rebate_given.nil?
        user.rebate_given = false
        user.save
      end
    end

    change_column_null :users, :rebate_given, false
  end
end
