class RenameCortegeAssociationColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :corteges, :association, :student_association
  end
end
