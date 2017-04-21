class AddDateToFunkisShift < ActiveRecord::Migration[5.0]
  def change
    change_table :funkis_shifts do |t|
      t.string :date, default: '', null: false
    end
  end
end
