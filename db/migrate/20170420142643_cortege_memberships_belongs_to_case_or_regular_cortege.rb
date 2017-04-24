class CortegeMembershipsBelongsToCaseOrRegularCortege < ActiveRecord::Migration[5.0]
  def change
    add_reference :cortege_memberships, :cortege, foreign_key: true
    add_reference :cortege_memberships, :case_cortege, foreign_key: true
  end
end
