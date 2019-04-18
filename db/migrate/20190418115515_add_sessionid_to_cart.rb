class AddSessionidToCart < ActiveRecord::Migration[5.0]
  def change
    add_column :carts, :session_id, :string
    add_column :carts, :session_updated_at, :datetime
  end
end
