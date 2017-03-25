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
        #['Kårtegeanmälan', '/cortege/interest', true, '', 0, true, []],
        ['Casekårtegeanmälan', '/case_cortege/new', true, '', 0, true, []],
    ]],
    ['Kontakt', '#', true, 'contact', 0, true, [
        ['Press', '/contact/press', true, '', 0, true, []],
        ['Funkis', '/contact/funkis', true, '', 0, true, []],
        ['Orkestrar', '/contact/orchestra', true, '', 0, true, []],
        ['Kårtege', '/contact/cortege', true, '', 0, true, []],
        ['Biljetter', '/contact/tickets', true, '', 0, true, []],
        ['It/Webbsupport', '/contact/it', true, '', 0, true, []]
    ]],
    ['Administration', '#', true, 'admin', 0, false, [
        ['Hantera användare', '/manage/users', true, '', Permission::LIST_USERS, true, []],
        ['Hantera orkestrar', '/manage/orchestras', true, '', Permission::LIST_ORCHESTRA_SIGNUPS, true, []],
        ['Hantera kårteger', '/manage/corteges', true, '', Permission::LIST_CORTEGE_APPLICATIONS, true, []],
        ['Hantera casekårteger', '/manage/case_corteges', true, '', Permission::LIST_CORTEGE_APPLICATIONS, true, []]
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


funkis_categories = [
    ['Mästerkatt', 'Insatsputte',
     'Anser du dig vara en räddare i nöden? Insatsfunkisarna är där de behövs under festivalen och de klarar allt från att möta besökare i entrén till att utfordra dem med mat och dryck.',
    '50/100 p'],
    ['I-or', 'Byggfunkis',
    'Gillar du att bygga upp samma sak om och om igen? Då borde du hjälpa till att bygga upp det bästa festivalområdet i SOF:s historia!',
    '50 p'],
    ['Fast and Furious', 'Chaufför-funkis',
    'Dagdrömmer du ofta om biljakter och hemliga uppdrag? Då är detta jobbet för dig! Bli en av våra viktiga chaufförer och hjälp oss att under SOF-helgen transportera runt diverse föremål runtom i praktfulla Linkan! Självfallet är det krav på B-körkort!',
    '50 p'],
    ['Batman', 'Nattvaktsfunkis',
    'Likt Batman övervakar du SOFs dyrgripar mot skurkar och pateter om nätterna. Förverkliga dina läderlappsdrömmar; bli ett med natten och upprätta ordning på SOF!',
    '50 p'],
    ['Röjar-Ralf', 'Rivfunkis',
    'Har du en fallenhet för att sabba, demolera och allmänt röja? Som rivare får du chansen att få utlopp för ditt förödelsebehov! Riv ner allt från barer till boende!',
    '50 p'],
    ['Vallhund', 'Kårtegefunkis',
    'Har du alltid drömt om att ha makten att bestämma över trafiken? Var med och se till att Kårtegen tar sig fram snyggt och säkert genom Linköping. Uppgifter som att flagga trafiken rätt, eller åka med på flaket hos ett av Kårtegens bidrag kan bli dina.',
    '50 p'],
    ['Pappa Baloo', 'Boendefunkis',
    'För att orkestrarna ska ha det så bra som möjligt under SOF krävs det några extra omhändertagande funkisar som ser till att deras boende är tiptop. Du kan få göra allt från att fixa orkesterfrukost till att bygga sovsalar - allt för att de ska ha energi att orka spela ljuv musik till sena kvällen.',
    '50 p'],
    ['Pippi Långstrump', 'Logistikfunkis',
    'Är du starkast i världen? Eller nästan i alla fall? Under SOF-helgen finns det massor som ska bäras och lastas, och utrustning ska transporteras fram och tillbaka mellan stan och campus. Hugg i och hjälp till där du behövs!',
    '50 p'],
    ['Zazu', 'Orkesterfunkis',
    'Ta hand om och vägled en orkester under deras vistelse här i Linköping! Som orkesterfadder blir du en vilsen orkesters guide, samtidigt som du blir festpartner åt en flock glada musiker! Du är därmed en av få funkisar som har tillåtelse att festa under arbetstid. Till skillnad från övriga pass, får du dessutom gratis inträde på festivalen de dagar som du jobbar istället för att få rabatterade priser.
Du ska finnas tillgänglig för din orkester under alla dagar som du anmäler dig på! Undrar du mer kontakta mottagning@sof17.se.',
    'Special']
]

def create_funkis_category(name, funkis_name, description, points)
  a = FunkisCategory.new
  a.name = name
  a.funkis_name = funkis_name
  a.description = description
  a.points = points
  a.save
  return a
end

FunkisCategory.delete_all
funkis_categories.each { |c| create_funkis_category *c }
