class UpdatePage < ActiveRecord::Migration[5.0]
  def change
    change_table :pages do |t|
      t.string :category,       default: 'index',   null: false
      t.string :page,           default: '',        null: false
      t.string :header,         default: '',        null: false
      t.text :content,          default: '',        null: false
      t.boolean :show_in_menu,  default: false,     null: false
    end
  end
end
