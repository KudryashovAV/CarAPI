require "rails_helper"

describe CarsController, type: :controller do
  before do
    recommended_cars = [
      { "car_id": 179, "rank_score": 0.945 },
      { "car_id": 5, "rank_score": 0.4552 },
      { "car_id": 13, "rank_score": 0.567 },
      { "car_id": 97, "rank_score": 0.9489 },
      { "car_id": 32, "rank_score": 0.0967 },
      { "car_id": 176, "rank_score": 0.0353 },
      { "car_id": 177, "rank_score": 0.1657 },
      { "car_id": 36, "rank_score": 0.7068 },
      { "car_id": 103, "rank_score": 0.4729 }
    ]
    stub_request(:get, "https://bravado-images-production.s3.amazonaws.com/recomended_cars.json").
      to_return(status: 200, body: recommended_cars.to_json)
  end

  after do
    WebMock.reset_executed_requests!
  end

  context "invalid request" do
    it "has bad request status" do
      get :index
      expect(response.status).to eq(400)
    end

    it "has error in body" do
      get :index
      expect(JSON.parse(response.body)).to eq({ "error" => "'user_id' parameter is required" })
    end
  end

  context "valid request" do
    let(:user) { create :user, preferred_price_range: 1_000..100_000 }

    let(:acura) { create :brand, name: "Acura" }
    let(:bmw) { create :brand, name: "BMW" }

    let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }
    let!(:acura_mdx) { create :car, brand: acura, model: "MDX", price: 47424, id: 8 }
    let!(:acura_ilx) { create :car, brand: acura, model: "ILX", price: 37424, id: 54 }

    let!(:bmw_rsx) { create :car, brand: bmw, model: "X6", price: 58424, id: 13 }
    let!(:bmw_mdx) { create :car, brand: bmw, model: "X5", price: 147424, id: 45 }
    let!(:bmw_ilx) { create :car, brand: bmw, model: "X4", price: 137424, id: 5 }

    let!(:preferences) { create :preferred_brand, user: user, brand: bmw }

    it "calls CarRankingFetcher" do
      expect(Cars::RankingFetcher).to receive(:call).with(user.id.to_s).once
      get :index, params: { user_id: user.id }
    end

    it "has good request status" do
      get :index, params: { user_id: user.id }
      expect(response.status).to eq(200)
    end

    it "has correct response" do
      get :index, params: { user_id: user.id }
      expect(JSON.parse(response.body)).to eq([
        {
          "brand" => {
            "id" => bmw.id,
            "name" => "BMW"
          },
          "id" => 13,
          "label" => "perfect_match",
          "model" => "X6",
          "price" => 58424,
          "rank_score" => 0.567
        },
        {
          "brand" => {
            "id" => bmw.id,
            "name" => "BMW"
          },
          "id" => 5,
          "label" => "good_match",
          "model" => "X4",
          "price" => 137424,
          "rank_score" => 0.4552
        },
        {
          "brand" => {
            "id" => bmw.id,
            "name" => "BMW"
          },
          "id" => 45,
          "label" => "good_match",
          "model" => "X5",
          "price" => 147424,
          "rank_score" => nil
        },
        {
          "brand" => {
            "id" => acura.id,
            "name" => "Acura"
          },
          "id" => 179,
          "label" => nil,
          "model" => "RSX",
          "price" => 57424,
          "rank_score" => 0.945
        },
        {
          "brand" => {
            "id" => acura.id,
            "name" => "Acura"
          },
          "id" => 54,
          "label" => nil,
          "model" => "ILX",
          "price" => 37424,
          "rank_score" => nil
        },
        {
          "brand" => {
            "id" => acura.id,
            "name" => "Acura"
          },
          "id" => 8,
          "label" => nil,
          "model" => "MDX",
          "price" => 47424,
          "rank_score" => nil
        },
      ])
    end
  end

  context "valid request with user id and brand name" do
    let(:user) { create :user, preferred_price_range: 1_000..100_000 }

    let(:acura) { create :brand, name: "Acura" }
    let(:bmw) { create :brand, name: "BMW" }

    let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }
    let!(:acura_mdx) { create :car, brand: acura, model: "MDX", price: 47424, id: 8 }
    let!(:acura_ilx) { create :car, brand: acura, model: "ILX", price: 37424, id: 54 }

    let!(:bmw_rsx) { create :car, brand: bmw, model: "X6", price: 157424, id: 13 }
    let!(:bmw_mdx) { create :car, brand: bmw, model: "X5", price: 147424, id: 45 }
    let!(:bmw_ilx) { create :car, brand: bmw, model: "X4", price: 137424, id: 5 }

    let!(:preferences) { create :preferred_brand, user: user, brand: bmw }

    it "has correct response" do
      get :index, params: { user_id: user.id, query: "Acu" }
      expect(JSON.parse(response.body)).to eq([{
                                                 "brand" => {
                                                   "id" => acura.id,
                                                   "name" => "Acura"
                                                 },
                                                 "id" => 179,
                                                 "label" => nil,
                                                 "model" => "RSX",
                                                 "price" => 57424,
                                                 "rank_score" => 0.945
                                               },
                                               {
                                                 "brand" => {
                                                   "id" => acura.id,
                                                   "name" => "Acura"
                                                 },
                                                 "id" => 54,
                                                 "label" => nil,
                                                 "model" => "ILX",
                                                 "price" => 37424,
                                                 "rank_score" => nil
                                               },
                                               {
                                                 "brand" => {
                                                   "id" => acura.id,
                                                   "name" => "Acura"
                                                 },
                                                 "id" => 8,
                                                 "label" => nil,
                                                 "model" => "MDX",
                                                 "price" => 47424,
                                                 "rank_score" => nil
                                               },])
    end
  end

  context "valid request with user id and min price" do
    let(:user) { create :user, preferred_price_range: 1_000..100_000 }

    let(:acura) { create :brand, name: "Acura" }
    let(:bmw) { create :brand, name: "BMW" }

    let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }
    let!(:acura_mdx) { create :car, brand: acura, model: "MDX", price: 157424, id: 8 }
    let!(:acura_ilx) { create :car, brand: acura, model: "ILX", price: 37424, id: 54 }

    let!(:bmw_rsx) { create :car, brand: bmw, model: "X6", price: 57424, id: 13 }
    let!(:bmw_mdx) { create :car, brand: bmw, model: "X5", price: 147424, id: 45 }
    let!(:bmw_ilx) { create :car, brand: bmw, model: "X4", price: 137424, id: 5 }

    let!(:preferences) { create :preferred_brand, user: user, brand: bmw }

    it "has correct response" do
      get :index, params: { user_id: user.id, price_min: 100_000 }
      expect(JSON.parse(response.body)).to eq([
                                                {
                                                  "brand" => {
                                                    "id" => bmw.id,
                                                    "name" => "BMW"
                                                  },
                                                  "id" => 5,
                                                  "label" => "good_match",
                                                  "model" => "X4",
                                                  "price" => 137424,
                                                  "rank_score" => 0.4552
                                                },
                                                {
                                                  "brand" => {
                                                    "id" => bmw.id,
                                                    "name" => "BMW"
                                                  },
                                                  "id" => 45,
                                                  "label" => "good_match",
                                                  "model" => "X5",
                                                  "price" => 147424,
                                                  "rank_score" => nil
                                                },
                                                {
                                                  "brand" => {
                                                    "id" => acura.id,
                                                    "name" => "Acura"
                                                  },
                                                  "id" => 8,
                                                  "label" => nil,
                                                  "model" => "MDX",
                                                  "price" => 157424,
                                                  "rank_score" => nil
                                                },
                                              ])
    end
  end

  context "valid request with user id and max price" do
    let(:user) { create :user, preferred_price_range: 1_000..100_000 }

    let(:acura) { create :brand, name: "Acura" }
    let(:bmw) { create :brand, name: "BMW" }

    let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }
    let!(:acura_mdx) { create :car, brand: acura, model: "MDX", price: 47424, id: 8 }
    let!(:acura_ilx) { create :car, brand: acura, model: "ILX", price: 37424, id: 54 }

    let!(:bmw_rsx) { create :car, brand: bmw, model: "X6", price: 58424, id: 13 }
    let!(:bmw_mdx) { create :car, brand: bmw, model: "X5", price: 147424, id: 45 }
    let!(:bmw_ilx) { create :car, brand: bmw, model: "X4", price: 137424, id: 5 }

    let!(:preferences) { create :preferred_brand, user: user, brand: bmw }

    it "has correct response" do
      get :index, params: { user_id: user.id, price_max: 100_000 }
      expect(JSON.parse(response.body)).to eq([
                                                {
                                                  "brand" => {
                                                    "id" => bmw.id,
                                                    "name" => "BMW"
                                                  },
                                                  "id" => 13,
                                                  "label" => "perfect_match",
                                                  "model" => "X6",
                                                  "price" => 58424,
                                                  "rank_score" => 0.567
                                                },
                                                {
                                                  "brand" => {
                                                    "id" => acura.id,
                                                    "name" => "Acura"
                                                  },
                                                  "id" => 179,
                                                  "label" => nil,
                                                  "model" => "RSX",
                                                  "price" => 57424,
                                                  "rank_score" => 0.945
                                                },
                                                {
                                                  "brand" => {
                                                    "id" => acura.id,
                                                    "name" => "Acura"
                                                  },
                                                  "id" => 54,
                                                  "label" => nil,
                                                  "model" => "ILX",
                                                  "price" => 37424,
                                                  "rank_score" => nil
                                                },
                                                {
                                                  "brand" => {
                                                    "id" => acura.id,
                                                    "name" => "Acura"
                                                  },
                                                  "id" => 8,
                                                  "label" => nil,
                                                  "model" => "MDX",
                                                  "price" => 47424,
                                                  "rank_score" => nil
                                                },
                                              ])
    end
  end

  context "valid request with user id, brand name, min price, and max price" do
    let(:user) { create :user, preferred_price_range: 1_000..100_000 }

    let(:acura) { create :brand, name: "Acura" }
    let(:bmw) { create :brand, name: "BMW" }

    let!(:acura_rsx) { create :car, brand: acura, model: "RSX", price: 57424, id: 179 }
    let!(:acura_mdx) { create :car, brand: acura, model: "MDX", price: 47424, id: 8 }
    let!(:acura_ilx) { create :car, brand: acura, model: "ILX", price: 37424, id: 54 }

    let!(:bmw_rsx) { create :car, brand: bmw, model: "X6", price: 58424, id: 13 }
    let!(:bmw_mdx) { create :car, brand: bmw, model: "X5", price: 147424, id: 45 }
    let!(:bmw_ilx) { create :car, brand: bmw, model: "X4", price: 137424, id: 5 }

    let!(:preferences) { create :preferred_brand, user: user, brand: bmw }

    it "has correct response" do
      get :index, params: { user_id: user.id, query: "Acu", price_min: 50_000, price_max: 60_000  }
      expect(JSON.parse(response.body)).to eq([
                                                {
                                                  "brand" => {
                                                    "id" => acura.id,
                                                    "name" => "Acura"
                                                  },
                                                  "id" => 179,
                                                  "label" => nil,
                                                  "model" => "RSX",
                                                  "price" => 57424,
                                                  "rank_score" => 0.945
                                                }
                                              ])
    end
  end
end
