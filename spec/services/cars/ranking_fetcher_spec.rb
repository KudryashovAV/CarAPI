require "rails_helper"

describe Cars::RankingFetcher do
  context "when car rank exist for user" do
    let(:user) { create :user, preferred_price_range: 1_000..100_000 }
    let(:acura) { create :brand, name: "Acura" }
    let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }
    let!(:car_ranking) { create :car_ranking, rank_score: 0.1905, car: acura_rsx, user: user }

    it "returns records" do
      expect(described_class.call(user.id).size).to eq(1)
    end

    it "returns correct record structure" do
      expect(described_class.call(user.id).first.attributes).to include({ "id" => car_ranking.id,
                                                                          "user_id" => user.id,
                                                                          "car_id" => acura_rsx.id,
                                                                          "rank_score" => a_kind_of(BigDecimal),
                                                                          "created_at" => a_kind_of(Time),
                                                                          "updated_at" => a_kind_of(Time)})
    end
  end

  context "when car ranks do not exist for user" do
    let(:user) { create :user, preferred_price_range: 1_000..100_000 }
    let(:acura) { create :brand, name: "Acura" }
    let(:bmw) { create :brand, name: "BMW" }
    let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }

    let!(:preferences) { create :preferred_brand, user: user, brand: bmw }

    before do
      recommended_cars = [
        { "car_id": 179, "rank_score": 0.945 }
      ]
      stub_request(:get, "https://bravado-images-production.s3.amazonaws.com/recomended_cars.json").
        to_return(status: 200, body: recommended_cars.to_json)
    end

    it "creates records" do
      expect { described_class.call(user.id) }.to change(CarRanking, :count).from(0).to(1)
    end

    it "makes 2 call to database" do
      expect { described_class.call(user.id) }.to make_database_queries(count: 2)
    end

    it "returns correct record structure" do
      expect(described_class.call(user.id).first).to include({ "user_id" => user.id,
                                                               "car_id" => acura_rsx.id,
                                                               "rank_score" => a_kind_of(BigDecimal) })
    end
  end

  context "when API call returns error" do
    let(:user) { create :user, preferred_price_range: 1_000..100_000 }
    let(:acura) { create :brand, name: "Acura" }
    let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }

    let!(:preferences) { create :preferred_brand, user: user, brand: acura }

    before do
      stub_request(:get, "https://bravado-images-production.s3.amazonaws.com/recomended_cars.json").
        to_return(status: [500, "Internal Server Error"])
    end

    it "does not create records" do
      expect { described_class.call(user.id) }.not_to change(CarRanking, :count)
    end

    it "works correctly" do
      expect(described_class.call(user.id)).to match_array([])
    end
  end
end
