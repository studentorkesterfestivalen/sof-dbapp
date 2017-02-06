class MoveExtraPerformancesColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :orchestras, :other_performances, :text
    change_table :orchestra_signups do |t|
      t.text :other_performances, default: nil
    end
  end
end
