class CreateArtistLineups < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_lineups do |t|

      t.timestamps
    end
  end
end
