class AddTimestampsCortegeLineups < ActiveRecord::Migration[5.0]
  def change
    add_column(:cortege_lineups, :created_at, :datetime)
    add_column(:cortege_lineups, :updated_at, :datetime)
  end
end
