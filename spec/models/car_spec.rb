require "rails_helper"

describe Car do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:acura) { create :brand, name: "Acura" }

  let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }

  let!(:car_ranking1) { create :car_ranking, rank_score: 0.1205, car: acura_rsx, user: user1 }
  let!(:car_ranking2) { create :car_ranking, rank_score: 0.1605, car: acura_rsx, user: user2 }

  it "has relation to car ranking" do
    expect(acura_rsx.car_rankings.pluck(:id)).to match_array([car_ranking1.id, car_ranking2.id])
  end
end
