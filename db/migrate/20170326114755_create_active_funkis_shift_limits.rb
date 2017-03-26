class CreateActiveFunkisShiftLimits < ActiveRecord::Migration[5.0]
  def change
    create_table :active_funkis_shift_limits do |t|
      t.integer :active_limit, default: 0

      t.timestamps
    end
  end
end
