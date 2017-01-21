class MenuItem < ApplicationRecord
  has_many :menu_items, :foreign_key => "parent_id"
end
