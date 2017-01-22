class UpdatePages < ActiveRecord::Migration[5.0]
  def change
    change_table :pages do |t|
      t.string :image
    end
  end
end
