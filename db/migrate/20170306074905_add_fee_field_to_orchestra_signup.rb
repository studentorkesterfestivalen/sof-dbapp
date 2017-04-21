class AddFeeFieldToOrchestraSignup < ActiveRecord::Migration[5.0]
  def change
    change_table :orchestra_signups do |t|
      t.boolean :is_late_registration, default: false, null: false
    end
  end
end
