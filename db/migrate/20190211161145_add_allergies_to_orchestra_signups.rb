class AddAllergiesToOrchestraSignups < ActiveRecord::Migration[5.0]
  def change
    add_column :orchestra_signups, :allergies, :string
  end
end
