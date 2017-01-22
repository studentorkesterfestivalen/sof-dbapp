# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



test_menu_items = [
    ['Kontakt', true, [
        ['Press', true, []]
    ]
    ],
    ['Festival', true, []],
]

def create_menu_item(title, active, children)
  a = MenuItem.new
  a.title = title
  a.active = active
  a.menu_items = children.map { |c| create_menu_item *c }
  a.save
  return a
end


test_menu_items.each { |c| create_menu_item *c }
