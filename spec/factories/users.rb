FactoryBot.define do
  factory :user do
    email { "test@test.com" }
    preferred_price_range { 1_000..100_000 }

  end
end
