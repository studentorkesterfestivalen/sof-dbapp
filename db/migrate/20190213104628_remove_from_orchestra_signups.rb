class RemoveFromOrchestraSignups < ActiveRecord::Migration[5.0]
  def change
    remove_column :orchestra_signups, :allergies, :string
  end
end
