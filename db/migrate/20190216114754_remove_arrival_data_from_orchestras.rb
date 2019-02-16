class RemoveArrivalDataFromOrchestras < ActiveRecord::Migration[5.0]
  def change
    remove_column :orchestras, :arrival_data, :integer
  end
end
