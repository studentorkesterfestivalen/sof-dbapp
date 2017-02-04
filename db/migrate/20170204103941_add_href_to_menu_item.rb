class AddHrefToMenuItem < ActiveRecord::Migration[5.0]
  def change
    change_table :menu_items do |t|
      t.string :href, default: '#', null: false
    end
  end
end
