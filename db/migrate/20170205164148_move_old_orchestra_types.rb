class MoveOldOrchestraTypes < ActiveRecord::Migration[5.0]
  def self.up
    if Rails.env.production?
      execute 'UPDATE orchestras SET orchestra_type = CASE ballet WHEN true THEN 1 ELSE 0 END'
    else
      # Migration disabled for non-production databases since command does not work for sqlite3
    end
  end
end
