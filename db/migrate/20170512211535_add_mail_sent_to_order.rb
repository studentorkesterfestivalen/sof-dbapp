class AddMailSentToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :receipt_sent, :boolean, default: false, null: false
  end
end
