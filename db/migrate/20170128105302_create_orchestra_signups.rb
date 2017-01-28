class CreateOrchestraSignups < ActiveRecord::Migration[5.0]
  def change
    create_table :orchestra_signups do |t|
      t.boolean :dormitory, null: true
      t.boolean :active_member
      t.boolean :consecutive_10
      t.boolean :attended_25
      t.integer :instrument_size

      t.timestamps
    end
  end
end
