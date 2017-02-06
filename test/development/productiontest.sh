read -p "Enter Kobra API key: " kobra

export LC_CTYPE=C
export DATABASE_URL="postgresql://vagrant@localhost/vagrant"
export RAILS_ENV=production
export SECRET_KEY_BASE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
export KOBRA_API_KEY=$kobra
export DISABLE_DATABASE_ENVIRONMENT_CHECK=1

rake db:drop db:create db:migrate db:seed
rails s -p 3001
