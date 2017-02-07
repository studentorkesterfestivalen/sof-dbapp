class AddOrchestraType < ActiveRecord::Migration[5.0]
  def change
    change_table :orchestras do |t|
      t.integer :orchestra_type, default: nil
    end
  end
end
