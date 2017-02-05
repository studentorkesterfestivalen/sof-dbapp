class MoveOldOrchestraTypes < ActiveRecord::Migration[5.0]
  def self.up
    Orchestra.update_all('orchestra_type=ballet')
  end
end
