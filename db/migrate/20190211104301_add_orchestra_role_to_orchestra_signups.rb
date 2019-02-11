class AddOrchestraRoleToOrchestraSignups < ActiveRecord::Migration[5.0]
  def change
    add_column :orchestra_signups, :orchestra_role, :integer
    add_column :orchestra_signups, :arrival_date, :integer
  end
end
