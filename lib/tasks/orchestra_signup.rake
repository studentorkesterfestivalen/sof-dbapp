namespace :orchestra_signup do
  task fix_dormitory: :environment do
    User.find_each do |u|
      # The time given is the exact minute the disabling of the dormitory was deployed.
      if u.orchestra_signup.present? and u.orchestra_signup.created_at > DateTime.parse('2017-04-13 17:14')
        u.orchestra_signup.dormitory = false
        u.orchestra_signup.save!
      end
    end
  end
end