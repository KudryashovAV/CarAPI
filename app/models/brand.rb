class Brand < ApplicationRecord
  has_many :preferred_brands, dependent: :destroy
  has_many :brand_preferred_users, through: :preferred_brands, source: :user
  has_many :cars, dependent: :destroy
end
