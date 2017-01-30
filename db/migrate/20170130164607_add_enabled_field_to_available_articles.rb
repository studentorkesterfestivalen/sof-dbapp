class AddEnabledFieldToAvailableArticles < ActiveRecord::Migration[5.0]
  def change
    change_table :available_articles do |t|
      t.boolean :enabled, default: true, null: false
    end
  end
end
