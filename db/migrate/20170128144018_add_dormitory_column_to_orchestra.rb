class AddDormitoryColumnToOrchestra < ActiveRecord::Migration[5.0]
  def change
    change_table :orchestras do |t|
      t.boolean :dormitory, default: false, null: false
    end
  end
end
