class CreateCorteges < ActiveRecord::Migration[5.0]
  def change
    create_table :corteges do |t|
      t.string :name, null: false, limit: 30
      t.string :association, null: true
      t.integer :participant_count, default: 0, null: false
      t.integer :cortege_type, null: false
      t.string :contact_phone, null: false
      t.text :idea, null: false
      t.text :comments, null: false

      t.boolean :approved, default: false, null: false
      t.string :status, default: 'pending', null: false

      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
