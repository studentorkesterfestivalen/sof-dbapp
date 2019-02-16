class AddDetailsToOrchestras < ActiveRecord::Migration[5.0]
  def change
    add_column :orchestras, :arrival_date, :integer
  end
end
