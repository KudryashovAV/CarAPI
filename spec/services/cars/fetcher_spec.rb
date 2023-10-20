require "rails_helper"

describe Cars::Fetcher do
  let(:user) { create :user, preferred_price_range: 1_000..100_000 }
  let(:acura) { create :brand, name: "Acura" }
  let(:bmw) { create :brand, name: "BMW" }
  let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 157424, id: 179 }
  let!(:acura_rs) { create :car, brand: acura, model: "RS", price: 57424, id: 2 }
  let!(:acura_mdx) { create :car, brand: acura, model: "MDX", price: 47424, id: 8 }
  let!(:acura_ilx) { create :car, brand: acura, model: "ILX", price: 37424, id: 54 }

  let!(:bmw_x5) { create :car, brand: bmw, model: "X5", price: 57424, id: 4 }
  let!(:bmw_x6) { create :car, brand: bmw, model: "X6", price: 77424, id: 13 }
  let!(:bmw_x4) { create :car, brand: bmw, model: "X4", price: 7424, id: 5 }

  let!(:car_ranking1) { create :car_ranking, rank_score: 0.1905, car: acura_rsx, user: user }
  let!(:car_ranking2) { create :car_ranking, rank_score: 0.1205, car: acura_rs, user: user }
  let!(:car_ranking3) { create :car_ranking, rank_score: 0.1605, car: bmw_x5, user: user }

  let!(:preferences) { create :preferred_brand, user: user, brand: acura }

  it "returns correct record structure" do
    expect(described_class.call(user_id: user.id).map(&:attributes)).to match_array(
                                                                          [{ "brand_id" => acura.id,
                                                                             "brand_name" => "Acura",
                                                                             "id" => 2,
                                                                             "model" => "RS",
                                                                             "price" => 57424,
                                                                             "rank_score" => a_kind_of(BigDecimal) },
                                                                           { "brand_id" => acura.id,
                                                                             "brand_name" => "Acura",
                                                                             "id" => 179,
                                                                             "model" => "RSX",
                                                                             "price" => 157424,
                                                                             "rank_score" => a_kind_of(BigDecimal) },
                                                                           { "brand_id" => bmw.id,
                                                                             "brand_name" => "BMW",
                                                                             "id" => 4,
                                                                             "model" => "X5",
                                                                             "price" => 57424,
                                                                             "rank_score" => a_kind_of(BigDecimal) },
                                                                           { "brand_id" => bmw.id,
                                                                             "brand_name" => "BMW",
                                                                             "id" => 5,
                                                                             "model" => "X4",
                                                                             "price" => 7424,
                                                                             "rank_score" => nil },
                                                                           { "brand_id" => acura.id,
                                                                             "brand_name" => "Acura",
                                                                             "id" => 54,
                                                                             "model" => "ILX",
                                                                             "price" => 37424,
                                                                             "rank_score" => nil },
                                                                           { "brand_id" => acura.id,
                                                                             "brand_name" => "Acura",
                                                                             "id" => 8,
                                                                             "model" => "MDX",
                                                                             "price" => 47424,
                                                                             "rank_score" => nil },
                                                                           { "brand_id" => bmw.id,
                                                                             "brand_name" => "BMW",
                                                                             "id" => 13,
                                                                             "model" => "X6",
                                                                             "price" => 77424,
                                                                             "rank_score" => nil }]
                                                                        )
  end

  it "returns correct record structure with correct order" do
    expect(described_class.call(user_id: user.id).map(&:id)).to eq([179, 4, 2, 5, 54, 8, 13])
  end
end
