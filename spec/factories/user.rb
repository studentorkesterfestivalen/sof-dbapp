FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email
    password 'password123'
    password_confirmation 'password123'
    admin_permissions 0

    trait :admin do
      admin_permissions 1
    end

    trait :with_cortege do
      after(:create) do |u|
        u.cortege = create(:cortege, user: u)
      end
    end
  end
end