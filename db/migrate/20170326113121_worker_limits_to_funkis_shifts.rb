class WorkerLimitsToFunkisShifts < ActiveRecord::Migration[5.0]
  def change
    remove_column :funkis_shifts, :maximum_workers
    change_table :funkis_shifts do |t|
      t.integer :red_limit, default: 0, null: false
      t.integer :yellow_limit, default: 0, null: false
      t.integer :green_limit, default: 0, null: false
    end
  end
end
