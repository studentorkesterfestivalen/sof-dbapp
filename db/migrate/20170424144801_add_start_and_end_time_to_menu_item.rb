class AddStartAndEndTimeToMenuItem < ActiveRecord::Migration[5.0]
  def change
    change_table :menu_items do |t|
      t.datetime :enabled_from
      t.datetime :disabled_from
    end
  end
end
