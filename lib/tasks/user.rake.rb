namespace :user do
  task :resend_confirmation, [:uid] => :environment do |t, args|
    if args[:uid]
      users = User.where('confirmation_token IS NOT NULL').and(User.where(:uid => args[:uid]))
      users.each do |user|
        user.send_confirmation_instructions
      end
    else
      puts 'Missing UID parameter.'
    end
  end
end