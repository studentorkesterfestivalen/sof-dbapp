class CreateCaseCorteges < ActiveRecord::Migration[5.0]
  def change
    create_table :case_corteges do |t|
      t.string :education, null: false
      t.string :contact_phone, null: false
      t.integer :case_cortege_type, null: false
      t.string :group_name, null: false
      t.text :motivation, null: false

      t.boolean :approved, default: false, null: false
      t.string :status, default: 'pending', null: false

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
