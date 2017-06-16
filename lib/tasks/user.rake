namespace :user do
  task :resend_confirmation => :environment do
    # Make sure arguments are collected properly
    ARGV.each { |a| task a.to_sym do ; end}

    if ARGV[1]
      puts "Trying to find user with uid: #{ARGV[1]}"
      user = User.where(uid: ARGV[1]).where(confirmed_at: nil).first
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

  task :sof_evaluation => :environment do
    User.find_each do |user|
      user.send_evaluation_email
    end
  end
end