class RemoveBalletColumnFromOrchestra < ActiveRecord::Migration[5.0]
  def change
    remove_column :orchestras, :ballet
    change_column :orchestras, :orchestra_type, :integer, default: 0, null: false
  end
end
