class Car < ApplicationRecord
  belongs_to :brand
  has_many :car_rankings
end
