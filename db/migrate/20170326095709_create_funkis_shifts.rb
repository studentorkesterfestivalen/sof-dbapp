class CreateFunkisShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :funkis_shifts do |t|
      t.string :day, null: false
      t.string :time, null: false
      t.integer :maximum_workers, null: false
      t.integer :points, null: true

      t.belongs_to :funkis_category, index: true

      t.timestamps
    end
  end
end
