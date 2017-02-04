class AddDisplayEmptyToMenuItem < ActiveRecord::Migration[5.0]
  def change
    change_table :menu_items do |t|
      t.boolean :display_empty, default: true, null: false
    end
  end
end
