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

    trait :with_members do
      transient do
        members_count 5
      end
    end
  end
end