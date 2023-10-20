FactoryBot.define do
  factory :car_ranking do
    rank_score { 0.0001 }
    association :car
    association :user
  end
end
