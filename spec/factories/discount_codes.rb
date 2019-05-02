FactoryGirl.define do
  factory :discount_code do
    discount 1
    uses 1
    product nil
  end
end
