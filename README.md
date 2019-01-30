#RESTful API for SOF

##Useful Rail commands:

Make sure you're in the correct project folder.

To run the server:
```
$rails server
```
or
```
$rails s
```

To start a console for the database:
```
$rails dbconsole
```

To see all the possible calls for the RESTful API:
```
$rails routes
```

##Deployment
Requires sqlite3 and ruby

To install bundler
```
$gem install bundler
```

To install ruby on rails:
```
$gem install rails
```

Run the setup file for the project
```
$ruby /bin/setup
```

This will install all dependencies from the gemfile etc.
(can also be done with ```$bundle install```)

After this you _might_ have to update which versions you're using in the gemfile.

Then you should be good to go, enjoy!

##External librarys used

For [authentification](https://github.com/lynndylanhurley/devise_token_auth) (login, registration, etc.):


##File structure
If you're looking at a ruby on rails project for the first time this might be a
little confusing. [Here's](https://www.javatpoint.com/ruby-on-rails-directory-structure) a short intro.
For more extensive info; Google is your friend.
