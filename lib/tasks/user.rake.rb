namespace :user do
  task :resend_confirmation, [:uid] => :environment do |t, args|
    users = User.where('confirmation_token IS NOT NULL').and(User.where(:uid => args[:uid]))
    users.each do |user|
      user.send_confirmation_instructions
    end
  end
end