class AllowNullCommentsInCortege < ActiveRecord::Migration[5.0]
  def change
    change_column :corteges, :comments, :text, null: true
  end
end
