require "rails_helper"

describe Cars::ResponseBuilder do
  let(:user) { create :user, preferred_price_range: 1_000..100_000 }

  let(:acura) { create :brand, name: "Acura", id: 3 }
  let(:bmw) { create :brand, name: "BMW", id: 5  }

  let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }
  let!(:acura_mdx) { create :car, brand: acura, model: "MDX", price: 147424, id: 8 }
  let!(:acura_ilx) { create :car, brand: acura, model: "ILX", price: 137424, id: 54 }

  let!(:bmw_x6) { create :car, brand: bmw, model: "X6", price: 58424, id: 13 }
  let!(:bmw_x5) { create :car, brand: bmw, model: "X5", price: 147424, id: 45 }
  let!(:bmw_x4) { create :car, brand: bmw, model: "X4", price: 137424, id: 5 }

  let!(:preferences) { create :preferred_brand, user: user, brand: acura }

  let(:raw_cars) {[
    OpenStruct.new(id: 179, brand_id: 3, brand_name: "Acura", model: "RSX", price: 57424, rank_score: 0.945),
    OpenStruct.new(id: 8, brand_id: 3, brand_name: "Acura", model: "MDX", price: 147424, rank_score: 0.935),
    OpenStruct.new(id: 54, brand_id: 3, brand_name: "Acura", model: "ILX", price: 137424, rank_score: 0.925),
    OpenStruct.new(id: 45, brand_id: 5, brand_name: "BMW", model: "X5", price: 58424, rank_score: 0.235),
    OpenStruct.new(id: 5, brand_id: 5, brand_name: "BMW", model: "X4", price: 137424, rank_score: nil),
    OpenStruct.new(id: 13, brand_id: 5, brand_name: "BMW", model: "X6", price: 147424, rank_score: nil)
  ]}

  it "returns correct record structure and order" do
    expect(described_class.call(raw_cars, user.id)).to eq([
      { id: 179, brand: { id: 3, name: "Acura" }, price: 57424, rank_score: 0.945, model: "RSX", label: "perfect_match" },
      { id: 8, brand: { id: 3, name: "Acura" }, price: 147424, rank_score: 0.935, model: "MDX", label: "good_match" },
      { id: 54, brand: { id: 3, name: "Acura" }, price: 137424, rank_score: 0.925, model: "ILX", label: "good_match" },
      { id: 45, brand: { id: 5, name: "BMW" }, price: 58424, rank_score: 0.235, model: "X5", label: nil },
      { id: 5, brand: { id: 5, name: "BMW" }, price: 137424, rank_score: nil, model: "X4", label: nil },
      { id: 13, brand: { id: 5, name: "BMW" }, price: 147424, rank_score: nil, model: "X6", label: nil }])
  end
end
