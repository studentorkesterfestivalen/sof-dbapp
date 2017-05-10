class RemoveArtistLineupTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :artist_lineups
  end
end

