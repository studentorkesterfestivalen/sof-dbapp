class CreateOrchestraFoodTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :orchestra_food_tickets do |t|
      t.integer :kind
      t.string :diet

      t.timestamps
    end
  end
end
