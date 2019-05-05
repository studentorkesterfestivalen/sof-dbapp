class AddLiuCardNumberToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :liu_card_number, :string
  end
end
