class CreateFunkisApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :funkis_applications do |t|
      t.string :ssn, null: false
      t.string :phone, null: false
      t.string :tshirt_size, null: false
      t.text :allergies, null: false, default: ''
      t.boolean :drivers_license, null: false, default: false
      t.integer :presale_choice, null: false, default: 0

      t.datetime :terms_agreed_at, null: true

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
