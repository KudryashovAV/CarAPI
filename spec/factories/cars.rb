FactoryBot.define do
  factory :car do
    model { "testModel" }
    price { 1_000 }

    association :brand
  end
end
