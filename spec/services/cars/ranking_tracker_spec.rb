require "rails_helper"

describe Cars::RankingTracker do
  let!(:user1) { create :user }
  let!(:user2) { create :user }
  let(:acura_brand) { create :brand, name: "Acura" }
  let(:bmw_brand) { create :brand, name: "BMW" }
  let!(:acura_car) { create :car, brand: acura_brand, model: "RSX", price: 57424, id: 179 }
  let!(:bmw_car) { create :car, brand: bmw_brand, model: "X5", price: 57424, id: 200 }

  let!(:car_ranking) { create :car_ranking, rank_score: 0.1905, car: acura_car, user: user1 }

  let(:old_db_value) { [{ user_id: user1.id, rank_score: 0.1905 }] }
  let(:new_db_value) { [{ user_id: user1.id, rank_score: 0.945 },
                        { user_id: user1.id, rank_score: 0.645 },
                        { user_id: user2.id, rank_score: 0.945 },
                        { user_id: user2.id, rank_score: 0.645 }] }

  before do
    recommended_cars = [
      { "car_id": 179, "rank_score": 0.945 },
      { "car_id": 200, "rank_score": 0.645 }
    ]
    stub_request(:get, "https://bravado-images-production.s3.amazonaws.com/recomended_cars.json").
      to_return(status: 200, body: recommended_cars.to_json)
  end

  it "creates records" do
    expect { described_class.call }.to change(CarRanking, :count).from(1).to(4)
  end

  it "rewrites records" do
    expect(CarRanking.all.map { |cr| { user_id: cr.user.id, rank_score: cr.rank_score.to_f } })
      .to match_array(old_db_value)

    described_class.call

    expect(CarRanking.all.map { |cr| { user_id: cr.user.id, rank_score: cr.rank_score.to_f } })
      .to match_array(new_db_value)
  end
end
