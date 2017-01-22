class AddCategoryToMenu < ActiveRecord::Migration[5.0]
  def change
    change_table :menu_items do |t|
      t.string :category
    end
  end
end
