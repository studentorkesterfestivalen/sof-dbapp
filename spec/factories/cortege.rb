FactoryGirl.define do
  sequence :name do |n|
    "cortege#{n}"
  end

  sequence :student_association do |n|
    "student_association#{n}"
  end

  sequence :contact_phone do |n|
    "070453917#{n}"
  end


  factory :cortege do
    name
    student_association
    contact_phone
    cortege_type 0
    idea 'nonsense'
    user

    factory :cortege_with_members do
      transient do
        users_count 5
      end

      after(:create) do |cortege, evaluator|
        create_list(:user, evaluator.users_count, cortege: cortege)
      end
    end

  end
end