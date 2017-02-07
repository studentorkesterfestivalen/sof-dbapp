class AddAlternativePerformancesToOrchestraSignup < ActiveRecord::Migration[5.0]
  def change
    change_table :orchestras do |t|
      t.text :other_performances, default: nil
    end
  end
end
