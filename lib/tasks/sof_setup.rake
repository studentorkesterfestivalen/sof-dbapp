namespace :sof_setup do
  desc 'Waits for database connection'
  task wait_db: :environment do
    uri = URI.parse(ENV['DATABASE_URL'])

    puts 'Waiting for database...'
    conn = PG.connect(
        :host => uri.hostname,
        :port => uri.port,
        :dbname => uri.path[1..-1],
        :user => uri.user,
        :password => uri.password,
        :connect_timeout => 5.minutes
    )

    unless conn.status == PG::CONNECTION_OK
      raise 'Database connection could not be acquired, waited 5 minutes.'
    end

    puts 'Database is online!'
  end

end
