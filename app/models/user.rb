class User < ApplicationRecord
  has_many :preferred_brands, dependent: :destroy
  has_many :user_preferred_brands, through: :preferred_brands, source: :brand
  has_many :car_rankings, dependent: :destroy
end
