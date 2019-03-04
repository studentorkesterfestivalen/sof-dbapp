class AddSizeToOrchestraArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :orchestra_articles, :size, :integer
  end
end
