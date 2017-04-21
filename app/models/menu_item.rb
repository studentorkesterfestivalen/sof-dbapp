class MenuItem < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  def setup_for(user)
    @user = user
  end

  def should_show?(user=nil)
    return false unless active

    user ||= @user
    if menu_item_id.nil? and menu_items.empty? and not display_empty
      return false
    end

    has_sufficient_permissions?(user)
  end

  def has_sufficient_permissions?(user=nil)
    user ||= @user
    if user.nil?
      required_permissions == 0
    else
      user.has_admin_permission? required_permissions
    end
  end

  def menu_items
    (super + automatic_menu_items).select { |x| x.should_show?(@user) }
  end

  def automatic_menu_items
    Page.where(category: category, show_in_menu: true).map do |page|
      MenuItem.new(
          title: page.header,
          active: true,
          href: page.href
      )
    end
  end
end
