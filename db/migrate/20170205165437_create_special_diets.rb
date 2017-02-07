class CreateSpecialDiets < ActiveRecord::Migration[5.0]
  def change
    create_table :special_diets do |t|
      t.string :name, null: false
      t.boolean :is_default, default: false, null: false
      t.belongs_to :orchestra_signup, index: true

      t.timestamps
    end
  end
end
