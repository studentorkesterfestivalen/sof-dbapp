class CreateCortegeMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :cortege_memberships do |t|

      t.timestamps
    end
  end
end
