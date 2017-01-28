class CreateOrchestraTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :orchestra_tickets do |t|
      t.integer :kind

      t.timestamps
    end
  end
end
