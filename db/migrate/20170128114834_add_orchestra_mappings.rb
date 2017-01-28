class AddOrchestraMappings < ActiveRecord::Migration[5.0]
  def change
    change_table :orchestras do |t|
      t.belongs_to :user, index: true
    end
    change_table :orchestra_signups do |t|
      t.belongs_to :orchestra, index: true
      t.belongs_to :user, index: true
    end
    change_table :orchestra_tickets do |t|
      t.belongs_to :orchestra_signup, index: true
    end
    change_table :orchestra_food_tickets do |t|
      t.belongs_to :orchestra_signup, index: true
    end
    change_table :orchestra_articles do |t|
      t.belongs_to :orchestra_signup, index: true
    end
  end
end
