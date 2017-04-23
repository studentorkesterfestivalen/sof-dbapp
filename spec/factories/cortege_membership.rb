FactoryGirl.define do
  factory :cortege_membership, :class => 'CortegeMembership' do
    user
    cortege

  end
end