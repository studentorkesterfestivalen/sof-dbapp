class ChangeDataFieldsToIntInSignup < ActiveRecord::Migration[5.0]
  def change
      change_column :orchestra_articles, :data, 'integer using cast(data as integer)'
  end
end
