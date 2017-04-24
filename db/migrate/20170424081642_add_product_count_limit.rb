class AddProductCountLimit < ActiveRecord::Migration[5.0]
  def change
    change_table :products do |t|
      t.integer :max_num_available, default: 0, null: false
    end
  end
end
