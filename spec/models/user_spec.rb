require "rails_helper"

describe User do
  let(:user) { create :user }
  let(:acura) { create :brand, name: "Acura" }
  let(:bmw) { create :brand, name: "BMW" }

  let!(:preferences1) { create :preferred_brand, user: user, brand: acura }
  let!(:preferences2) { create :preferred_brand, user: user, brand: bmw }

  it "has relation to preferred brands" do
    expect(user.user_preferred_brands.pluck(:id)).to match_array([acura.id, bmw.id])
  end
end
