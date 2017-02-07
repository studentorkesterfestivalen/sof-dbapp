class EnsureOrchestraAccessCodeUnique < ActiveRecord::Migration[5.0]
  def change
    change_column :orchestras, :code, :string, unique: true
  end
end
