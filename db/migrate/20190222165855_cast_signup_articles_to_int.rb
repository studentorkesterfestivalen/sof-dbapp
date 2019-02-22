class CastSignupArticlesToInt < ActiveRecord::Migration[5.0]
  def change
      change_column :orchestra_articles, :data, 'integer USING data::integer'
  end
end
