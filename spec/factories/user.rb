FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end


FactoryGirl.define do
  factory :user, :class => 'User' do
    email
    password '123456'
    password_confirmation '123456'
    user.admin_permissions 0
  end
end

FactoryGirl.define do
  factory :admin, :class => 'User' do
    email
    password 'password'
    password_confirmation 'password'
    admin_permissions 1
    end
end