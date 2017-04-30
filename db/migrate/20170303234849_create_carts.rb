class CreateCarts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts do |t|
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
