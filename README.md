# RESTful API for SOF

## Useful Rail commands:

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

## Deployment
Requires PostgreSQL and ruby

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

This will install all dependencies from the gemfile and setup database.
(can also be done with ```$bundle install``` to install dependencies and ```ruby bin/rails db:setup``` to setup database)

After this you _might_ have to update which versions you're using in the gemfile.

Then you should be good to go, enjoy!

## External libraries used

For [authentification](https://github.com/lynndylanhurley/devise_token_auth) (login, registration, etc.):

To get local smtp server up and running for local development use [mailcatcher](https://mailcatcher.me/).
```$gem install mailcatcher``` and then ```$mailcatcher``` will start the smtp server at http://localhost:1025. You can see all e-mails sent at http://localhost:1080.
**Do not include mailcatcher in your gemfile**

## File structure
If you're looking at a ruby on rails project for the first time this might be a
little confusing. [Here's](https://www.javatpoint.com/ruby-on-rails-directory-structure) a short intro.
For more extensive info; Google is your friend.
