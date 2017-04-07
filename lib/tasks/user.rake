namespace :user do
  task :resend_confirmation => :environment do

    ARGV.each { |a| task a.to_sym do ; end}



    if ARGV[1]
      puts "Trying to find user with uid: #{ARGV[1]}"
      user = User.where('confirmation_token IS NOT NULL', uid: ARGV[1])
      if user
        puts "Resending confirmation mail to #{ARGV[1]}"
        user.send_confirmation_instructions
      else
        puts "Can't find user in database."
      end
    else
      puts 'Missing UID parameter.'
    end
  end
end