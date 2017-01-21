export DATABASE_URL="postgresql://vagrant@localhost/vagrant"
export RAILS_ENV=production
export SECRET_KEY_BASE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

rake db:reset db:migrate db:seed
rails s -p 3001
