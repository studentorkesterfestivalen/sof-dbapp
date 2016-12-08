class AddRelationToMenuItem < ActiveRecord::Migration[5.0]
  def change
    add_reference :menu_items, :parent, foreign_key: true
  end
end
