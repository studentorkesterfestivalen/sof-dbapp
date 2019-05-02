# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



test_menu_items = [
    ['Butik', '#', enabled_from: '2017-04-23', children: [
        ['Handla', '/store'],
        ['Mina produkter', '/store/inventory'],
        ['Mina ordrar', '/store/orders'],
    ]],
    ['Frågor & Svar', '/faq'],
    ['Festivalen', '#', children: [
        ['SOF-armbandet', '/festival/bracelet'],
        ['Orkestrar', '/festival/artist_lineup'],
        ['Festivalschema', '/festival/schedule'],
        ['Spelschema', '/festival/orchestra/schedule'],
        ['Colour it', '/festival/colour_it'],
        ['Karta', '/festival/map'],
        ['Mat på området', '/festival/food'],
        ['Årets öl', '/festival/beer']
    ]],
    ['Kårtege', '#', children: [
        ['Kårtegeordning', '/cortege/lineups'],
        ['Kårtegens väg', '/cortege/map'],
        ['Om Kårtegen', '/cortege', active: false],
        ['Om Casekårtege', '/case_cortege', active: false],
        ['Kårtegeanmälan', '/cortege/interest', disabled_from: '2017-04-01'],
        ['Casekårtegeanmälan', '/case_cortege/new', disabled_from: '2017-04-01'],
    ]],
    ['Orkester', '#', children: [
        ['Information', '/orchestra'],
        ['Anmälan', '/orchestra/register'],
    ]],
    ['Jobba på SOF', '#', children: [
        ['Förmåner', '/funkis'],
        ['Funkiskategorier', '/funkis/categories'],
        ['Anmälan', '/funkis/application', enabled_from: '2017-04-22', disabled_from: '2017-04-29']
    ]],
    ['Kontakt', '#', children: [
        ['Huvudansvarig', '/contact/general'],
        ['Press', '/contact/press'],
        ['Funkis', '/contact/funkis'],
        ['Orkestrar', '/contact/orchestra'],
        ['Kårtege', '/contact/cortege'],
        ['Biljetter', '/contact/tickets'],
        ['It/Webbsupport', '/contact/it']
    ]],
    ['Administration', '#', display_empty: false, children: [
        ['Hantera användare', '/manage/users', permissions: AdminPermission::LIST_USERS],
        ['Hantera orkestrar', '/manage/orchestras', permissions: AdminPermission::ORCHESTRA_ADMIN],
        ['Hantera kårteger', '/manage/corteges', permissions: AdminPermission::LIST_CORTEGE_APPLICATIONS],
        ['Hantera lineups', '/manage/lineups', permissions: AdminPermission::LIST_CORTEGE_APPLICATIONS],
        ['Hantera casekårteger', '/manage/case_corteges', permissions: AdminPermission::LIST_CORTEGE_APPLICATIONS],
        ['Hantera produkter', '/manage/products', permissions: AdminPermission::ALL],
        ['Hantera FAQs', '/manage/faqs', permissions: AdminPermission::EDITOR],
        ['Funkis-statistik', '/manage/funkis', permissions: AdminPermission::LIST_FUNKIS_APPLICATIONS],
        ['Order-statistik', '/manage/products/statistics', permissions: AdminPermission::ANALYST],
        ['Lämna ut varor', '/manage/collect', permissions: AdminPermission::TICKETER]
    ]]
]

def create_menu_item(title, href, permissions: 0, display_empty: true, enabled_from: nil, disabled_from: nil, children: [], active: true)
  a = MenuItem.new
  a.title = title
  a.href = href
  a.required_permissions = permissions
  a.display_empty = display_empty
  a.enabled_from = enabled_from.present? ? DateTime.parse(enabled_from) : nil
  a.disabled_from = disabled_from.present? ? DateTime.parse(disabled_from) : nil
  a.menu_items = children.map { |c| create_menu_item *c }
  a.active = active
  a.save
  return a
end

MenuItem.delete_all
test_menu_items.each { |c| create_menu_item *c }

# Only seed in development if empty product database to avoid order and cart problems
if Rails.env.development? and BaseProduct.count == 0 and Product.count == 0
  BaseProduct.delete_all
  Product.delete_all


  weekend_ticket = BaseProduct.create(
    id: 1,
    name: 'Helhelgsbiljett',
    name_english: 'Weekend ticket',
    description: 'En biljett som räcker en hel helg',
    description_english: 'A ticket for a whole weekend',
    cost: 4000
  )

  weekend_prod = Product.create(
    max_num_available: 5
  )
  weekend_ticket.products.push(weekend_prod)

  single_day_ticket = BaseProduct.create(
    id: 2,
    name: 'Dagsbiljett',
    name_english: 'Day ticket',
    description: 'En biljett som räcker en dag',
    description_english: 'A ticket that lasts for a day',
    cost: 0
  )

  thursday = Product.create(
    kind: 'Torsdag',
    kind_english: 'Thursday',
    max_num_available: 5,
    cost: 1400
  )

  single_day_ticket.products.push(thursday)

  friday = Product.create(
    kind: 'Fredag',
    kind_english: 'Friday',
    max_num_available: 10,
    cost: 1600
  )

  single_day_ticket.products.push(friday)

  saturday = Product.create(
    kind: 'Lördag',
    kind_english: 'Saturday',
    cost: 1900
  )
  single_day_ticket.products.push(saturday)

  thurs_constraint = AmountConstraint.create(
    amount: 5
  )

  fri_constraint = AmountConstraint.create(
    amount: 10
   )

  sat_constraint = AmountConstraint.create(
    amount: 20
  )

  thursday.amount_constraints << thurs_constraint
  friday.amount_constraints  << fri_constraint
  saturday.amount_constraints  << sat_constraint

  weekend_prod.amount_constraints << thurs_constraint
  weekend_prod.amount_constraints  << fri_constraint
  weekend_prod.amount_constraints  << sat_constraint

  DiscountCode.create(
    uses: 1,
    discount: 100,
    product_id: weekend_prod.id,
    code: 'test'
  )

end

funkis_categories = [
    ['Mästerkatt', 'Insatsfunkis',
     'Anser du dig vara en räddare i nöden? Insatsfunkisarna är där de behövs under festivalen och de klarar allt från att möta besökare i entrén till att utfordra dem med mat och dryck. OBS: De pass markerade med en stjärna ger 100p.',
    '50/100 p', [
            {
                day: 'Torsdag',
                date: '11/5',
                time: '14:00-22:00',
                points: 50,
                red_limit: 18,
                yellow_limit: 22,
                green_limit: 28
            },
            {
                day: 'Torsdag',
                date: '11/5',
                time: '21:00-04:30',
                points: 100,
                red_limit: 32,
                yellow_limit: 38,
                green_limit: 42
            },
            {
                day: 'Fredag',
                date: '12/5',
                time: '14:00-22:00',
                points: 50,
                red_limit: 15,
                yellow_limit: 22,
                green_limit: 25
            },
            {
                day: 'Fredag',
                date: '12/5',
                time: '21:00-04:30',
                points: 100,
                red_limit: 30,
                yellow_limit: 38,
                green_limit: 42
            },
            {
                day: 'Lördag',
                date: '13/5',
                time: '15:00-23:00',
                points: 50,
                red_limit: 20,
                yellow_limit: 25,
                green_limit: 30
            },
            {
                day: 'Lördag',
                date: '13/5',
                time: '22:00-05:30',
                points: 100,
                red_limit: 30,
                yellow_limit: 38,
                green_limit: 40
            }
     ]],
    ['I-or', 'Byggfunkis',
    'Gillar du att bygga upp samma sak om och om igen? Då borde du hjälpa till att bygga upp det bästa festivalområdet i SOF:s historia!',
    '50 p', [
         {
             day: 'Onsdag',
             date: '10/5',
             time: '08:00-16:00',
             points: 50,
             red_limit: 8,
             yellow_limit: 10,
             green_limit: 12

         }
     ]],
    ['Fast and Furious', 'Chaufför-funkis',
    'Dagdrömmer du ofta om biljakter och hemliga uppdrag? Då är detta jobbet för dig! Bli en av våra viktiga chaufförer och hjälp oss att under SOF-helgen transportera runt diverse föremål runtom i praktfulla Linkan! Självfallet är det krav på B-körkort!',
    '50 p', [
         {
             day: 'Torsdag',
             date: '11/5',
             time: '20:00-03:30',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Fredag',
             date: '12/5',
             time: '20:00-03:30',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '20:00-03:30',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Torsdag',
             date: '11/5',
             time: '10:00-16:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 3
         },
         {
             day: 'Torsdag',
             date: '11/5',
             time: '16:00-22:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 3
         },
         {
             day: 'Fredag',
             date: '12/5',
             time: '10:00-16:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 3,
             green_limit: 3
         },
         {
             day: 'Fredag',
             date: '12/5',
             time: '16:00-22:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 3,
             green_limit: 3
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '07:00-13:00',
             points: 50,
             red_limit: 3,
             yellow_limit: 3,
             green_limit: 4
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '13:00-19:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 3,
             green_limit: 4
         },
         {
             day: 'Söndag',
             date: '14/5',
             time: '07:00-13:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 3
         },
         {
             day: 'Söndag',
             date: '14/5',
             time: '13:00-19:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 3
         }
     ]],
    ['Batman', 'Nattvaktsfunkis',
    'Likt Batman övervakar du SOFs dyrgripar mot skurkar och pateter om nätterna. Förverkliga dina läderlappsdrömmar; bli ett med natten och upprätta ordning på SOF!',
    '50 p', [
         {
             day: 'Lördag',
             date: '6/5',
             time: '22:00-08:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Söndag',
             date: '7/5',
             time: '22:00-08:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Måndag',
             date: '8/5',
             time: '22:00-08:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Tisdag',
             date: '9/5',
             time: '22:00-08:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Onsdag',
             date: '10/5',
             time: '22:00-08:00',
             points: 50,
             red_limit: 4,
             yellow_limit: 4,
             green_limit: 4
         }
     ]],
    ['Röjar-Ralf', 'Rivfunkis',
    'Har du en fallenhet för att sabba, demolera och allmänt röja? Som rivare får du chansen att få utlopp för ditt förödelsebehov! Riv ner allt från barer till boende!',
    '50 p', [
         {
             day: 'Söndag',
             date: '14/5',
             time: '08:00-16:00',
             points: 50,
             red_limit: 25,
             yellow_limit: 30,
             green_limit: 34
         },
         {
             day: 'Söndag',
             date: '14/5',
             time: '15:00-23:00',
             points: 50,
             red_limit: 19,
             yellow_limit: 25,
             green_limit: 31
         }
     ]],
    ['Vallhund', 'Kårtegefunkis',
    'Har du alltid drömt om att ha makten att bestämma över trafiken? Var med och se till att Kårtegen tar sig fram snyggt och säkert genom Linköping. Uppgifter som att flagga trafiken rätt, eller åka med på flaket hos ett av Kårtegens bidrag kan bli dina.',
    '50 p', [
         {
             day: 'Lördag',
             date: '13/5',
             time: '07:30-14:30',
             points: 50,
             red_limit: 4,
             yellow_limit: 4,
             green_limit: 4
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '08:00-15:00',
             points: 50,
             red_limit: 1,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '11:30-19:30',
             points: 50,
             red_limit: 30,
             yellow_limit: 32,
             green_limit: 32
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '11:30-14:30',
             points: 50,
             red_limit: 5,
             yellow_limit: 5,
             green_limit: 5
         }
     ]],
    ['Pappa Baloo', 'Boendefunkis',
    'För att orkestrarna ska ha det så bra som möjligt under SOF krävs det några extra omhändertagande funkisar som ser till att deras boende är tiptop. Du kan få göra allt från att fixa orkesterfrukost till att bygga sovsalar - allt för att de ska ha energi att orka spela ljuv musik till sena kvällen.',
    '50 p', [
         {
             day: 'Torsdag',
             date: '11/5',
             time: '23:00-07:00',
             points: 50,
             red_limit: 1,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Fredag',
             date: '12/5',
             time: '00:00-08:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Fredag',
             date: '12/5',
             time: '08:00-16:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Fredag',
             date: '12/5',
             time: '16:00-00:00',
             points: 50,
             red_limit: 1,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Fredag',
             date: '12/5',
             time: '23:00-07:00',
             points: 50,
             red_limit: 1,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '00:00-08:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '08:00-16:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '16:00-00:00',
             points: 50,
             red_limit: 1,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '23:00-07:00',
             points: 50,
             red_limit: 1,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Söndag',
             date: '14/5',
             time: '00:00-08:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Söndag',
             date: '14/5',
             time: '08:00-16:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Fredag & Lördag',
             date: '12/5 & 13/5',
             time: '08:00-16:00 resp. 18:00-23:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         },
         {
             day: 'Lördag',
             date: '13/5',
             time: '07:00-11:00 & 18:00-23:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 2,
             green_limit: 2
         }
     ]],
    ['Pippi Långstrump', 'Logistikfunkis',
    'Är du starkast i världen? Eller nästan i alla fall? Under SOF-helgen finns det massor som ska bäras och lastas, och utrustning ska transporteras fram och tillbaka mellan stan och campus. Hugg i och hjälp till där du behövs!',
    '50 p', [
         {
             day: 'Lördag & Söndag',
             date: '13/5 & 14/5',
             time: '06:00-09:30 resp. 08:00-12:00',
             points: 50,
             red_limit: 2,
             yellow_limit: 3,
             green_limit: 4
         }
     ]],
    ['Zazu', 'Orkesterfunkis',
    'Ta hand om och vägled en orkester under deras vistelse här i Linköping! Som orkesterfadder blir du en vilsen orkesters guide, samtidigt som du blir festpartner åt en flock glada musiker! Du är därmed en av få funkisar som har tillåtelse att festa under arbetstid. Till skillnad från övriga pass, får du dessutom gratis inträde på festivalen de dagar som du jobbar istället för att få rabatterade priser.
Du ska finnas tillgänglig för din orkester under alla dagar som du anmäler dig på! Undrar du mer kontakta mottagning@sof17.se.',
    'Special', [
         {
             day: 'Torsdag till Lördag',
             date: '11/5 till 13/5',
             time: 'Hela tiden',
             points: 0,
             red_limit: 7,
             yellow_limit: 7,
             green_limit: 7
         },
         {
             day: 'Fredag till Lördag',
             date: '12/5 till 13/5',
             time: 'Hela tiden',
             points: 0,
             red_limit: 12,
             yellow_limit: 12,
             green_limit: 12
         }
     ]]
]

def create_funkis_category(name, funkis_name, description, points, shifts)
  FunkisCategory.create!(
      name: name,
      funkis_name: funkis_name,
      description: description,
      points: points,
      funkis_shifts_attributes: shifts
  )
end


# THIS MUST ONLY BE DONE ONCE ON THE PRODUCTION DATABASE
# Still enabled on development and test so that its easy to test stuff.

if Rails.env.development? or Rails.env.test?
  FunkisApplication.delete_all
  FunkisCategory.delete_all
  FunkisShift.delete_all
  funkis_categories.each { |c| create_funkis_category *c }

  ActiveFunkisShiftLimit.delete_all
  ActiveFunkisShiftLimit.create!(
      active_limit: 0
  )
end
