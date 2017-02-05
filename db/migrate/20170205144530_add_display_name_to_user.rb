class AddDisplayNameToUser < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :display_name, default: nil
    end
  end
end
