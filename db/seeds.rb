# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



test_menu_items = [
    ['Orkester', '#', true, 'orchestra', 0, true, [
        ['Information', '/orchestra', true, '', 0, true, []],
        ['Anmälan', '/orchestra/register', true, '', 0, true, []],
    ]],
    ['Kårtege', '#', true, 'cortege', 0, true, [
        ['Om Kårtegen', '/cortege', true, '', 0, true, []],
        ['Om Casekårtege', '/case_cortege', true, '', 0, true, []],
        ['Kårtegeanmälan', '/cortege/interest', true, '', 0, true, []],
        ['Casekårtegeanmälan', '/case_cortege/new', true, '', 0, true, []],
    ]],
    ['Kontakt', '#', true, 'contact', 0, true, [
        ['Kommitté', '/contact', true, '', 0, true, []],
    ]],
    ['Administration', '#', true, 'admin', 0, false, [
        ['Hantera användare', '/manage/users', true, '', AdminPermission::LIST_USERS, true, []],
        ['Hantera orkestrar', '/manage/orchestras', true, '', AdminPermission::LIST_ORCHESTRA_SIGNUPS, true, []],
        ['Hantera kårteger', '/manage/corteges', true, '', AdminPermission::LIST_CORTEGE_APPLICATIONS, true, []],
        ['Hantera casekårteger', '/manage/case_corteges', true, '', AdminPermission::LIST_CORTEGE_APPLICATIONS, true, []]
    ]]
]

def create_menu_item(title, href, active, category, permissions, display_empty, children)
  a = MenuItem.new
  a.title = title
  a.href = href
  a.active = active
  a.category = category
  a.required_permissions = permissions
  a.display_empty = display_empty
  a.menu_items = children.map { |c| create_menu_item *c }
  a.save
  return a
end

MenuItem.delete_all
test_menu_items.each { |c| create_menu_item *c }


BaseProduct.delete_all
Product.delete_all

weekend_ticket = BaseProduct.create(
  id: 1,
  name: 'Helhelgsbiljett',
  description: 'En biljett som räcker en hel helg',
  cost: 5000
)

weekend_ticket.products.push(
  Product.create
)

single_day_ticket = BaseProduct.create(
  id: 2,
  name: 'Dagsbiljett',
  description: 'En biljett som räcker en dag',
  cost: 2000
)

single_day_ticket.products.push(
  Product.create(
    kind: 'Torsdag'
  )
)

single_day_ticket.products.push(
  Product.create(
    kind: 'Fredag'
  )
)

single_day_ticket.products.push(
  Product.create(
    kind: 'Lördag'
  )
)
