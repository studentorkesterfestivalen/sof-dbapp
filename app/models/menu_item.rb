class MenuItem < ApplicationRecord
  has_many :menu_items

  def menu_items
    super + automatic_menu_items
  end

  def automatic_menu_items
    Page.where(category: category, show_in_menu: true).map do |page|
      MenuItem.new(
          title: page.header,
          active: true
      )
    end
  end
end
