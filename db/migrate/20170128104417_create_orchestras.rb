class CreateOrchestras < ActiveRecord::Migration[5.0]
  def change
    create_table :orchestras do |t|
      t.string  :name, null: false
      t.string  :code, null: false
      t.boolean :ballet, default: false, null: false
      t.boolean :allow_signup, default: true

      t.timestamps
    end
  end
end
