# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



test_menu_items = [
    ['Kontakt', '#', true, 'contact', 0, true, [
        ['Press', '/press', true, '', 0, true, []]
    ]
    ],
    ['Festival', '/festival', true, 'festival', 0, true, []],
    ['Test', '/test', true, 'test', 0, true, []],
    ['Administration', '#', true, 'admin', 0, false, [
        ['Hantera användare', '/manage/users', true, '', Permission::LIST_USERS, true, []]
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

Page.delete_all
Page.create(category: "index", page: "", header: "Index", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas id quam nec enim tristique pharetra. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In odio augue, suscipit in leo id, elementum tristique lacus. Integer sollicitudin dui enim, non mollis erat condimentum nec. Duis consequat justo id elit convallis, a ullamcorper risus rhoncus. Donec tristique, augue sed lacinia scelerisque, nisl orci accumsan felis, at mattis nisi est eu justo. Quisque quis pellentesque purus. Vivamus porta nisi ac dui bibendum interdum. Integer quis mi in nulla tristique luctus. Quisque mattis arcu id orci scelerisque sollicitudin.", image: "", show_in_menu: false)

Page.create(category: "test", page: "", header: "Lorem Ipsum", content: " <img> <h> Neque porro quisquam </h> Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse tempus scelerisque dapibus. Ut consequat id erat nec tempor. Vivamus sit amet urna nec risus dignissim fringilla eget sit amet turpis. Cras pharetra sapien in nisi tincidunt, sed vulputate leo euismod. Quisque eu auctor mauris. Morbi venenatis sagittis consectetur. Proin euismod nisi ac consequat aliquam. Nunc tempor eros neque, ac placerat dolor pulvinar in. Suspendisse posuere sapien id nibh vehicula, a posuere ipsum fermentum. Mauris ornare mattis leo id cursus.

Interdum et malesuada fames ac ante ipsum primis in faucibus. Aliquam erat volutpat. Donec non vehicula tellus. Vestibulum imperdiet tempor nunc, nec volutpat diam scelerisque vel. Sed elementum ligula ut eleifend commodo. Pellentesque vitae condimentum erat. Nullam auctor augue ut imperdiet varius. Sed a volutpat ipsum.

Vestibulum finibus turpis sed condimentum commodo. Curabitur sed sodales orci, id luctus erat. Quisque libero ipsum, consequat sit amet magna vestibulum, vestibulum pharetra odio. In luctus turpis ac augue rutrum blandit. Aenean a luctus elit. Fusce semper dictum sagittis. Mauris leo mi, vestibulum a dignissim sodales, lacinia et ipsum. Praesent pellentesque tempor ex, eget sagittis nisi tempor sed. Nunc dignissim nec quam at volutpat.", image: "https://s3-eu-west-1.amazonaws.com/lintek-sof/sof-homepage/logos/Logga_SOF_pafarg2.png",  show_in_menu: true )

Page.create(category: "foo", page: "bar", header: "Foo Bar", content: " <img> <h> Test </h>  Foo Bar.", image: "https://s3-eu-west-1.amazonaws.com/lintek-sof/sof-homepage/logos/Logga_SOF_pafarg2.png",  show_in_menu: false )
