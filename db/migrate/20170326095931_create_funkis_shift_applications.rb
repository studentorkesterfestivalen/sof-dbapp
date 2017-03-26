class CreateFunkisShiftApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :funkis_shift_applications do |t|
      t.belongs_to :funkis_application, index: true
      t.belongs_to :funkis_shift, index: true

      t.timestamps
    end
  end
end
