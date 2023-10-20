FactoryBot.define do
  factory :preferred_brand do
    association :brand
    association :user
  end
end
