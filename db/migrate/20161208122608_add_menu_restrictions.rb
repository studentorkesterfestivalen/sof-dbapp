class AddMenuRestrictions < ActiveRecord::Migration[5.0]
  def change
    change_column_null :menu_items, :title, false
    change_column_null :menu_items, :active, false
    change_column_default :menu_items, :active, from: nil, to: false
  end
end
