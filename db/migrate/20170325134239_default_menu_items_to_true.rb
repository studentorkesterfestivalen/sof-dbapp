class DefaultMenuItemsToTrue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :menu_items, :active, true
  end
end
