class CreateMenuItems < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_items do |t|
      t.string :title
      t.boolean :active

      t.timestamps
    end
  end
end
