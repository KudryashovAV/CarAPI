require "rails_helper"

describe Brand do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:bmw) { create :brand, name: "BMW" }

  let!(:preferences1) { create :preferred_brand, user: user1, brand: bmw }
  let!(:preferences2) { create :preferred_brand, user: user2, brand: bmw }

  it "has relation to user preferred brands" do
    expect(bmw.brand_preferred_users.pluck(:id)).to match_array([user1.id, user2.id])
  end
end
