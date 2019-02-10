class AddEmailToOrchestra < ActiveRecord::Migration[5.0]
  def change
    add_column :orchestras, :email, :string
  end
end
