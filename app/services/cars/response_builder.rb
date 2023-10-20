class Cars::ResponseBuilder
  def self.call(cars, user_id)
    new(cars, user_id).call
  end

  def initialize(cars, user_id)
    @cars = cars
    @user_id = user_id
    @perfect_cars = []
    @good_cars = []
    @regular_cars = []
  end

  def call
    sort_cars

    build_data(@perfect_cars, "perfect_match") + build_data(@good_cars, "good_match") + build_data(@regular_cars)
  end

  private

  def sort_cars
    car_data = fetch_car_data

    @cars.each do |car|
      if car_data[car.id].blank?
        @regular_cars << car
      elsif car_data[car.id].find { |data| data["price"].include?(car.price)}.blank?
        @good_cars << car
      else
        @perfect_cars << car
      end
    end
  end

  def fetch_car_data
    User.left_joins(preferred_brands: { brand: :cars })
        .select("users.preferred_price_range as price, cars.id as car_id")
        .where(users: { id: @user_id }, cars: { id: @cars.map(&:id) })
        .group_by(&:car_id)
  end

  def build_data(cars, label = nil)
    cars.map do |car|
      {
        id: car.id,
        brand: {
          id: car.brand_id,
          name: car.brand_name
        },
        price: car.price,
        rank_score: car.rank_score&.to_f,
        model: car.model,
        label: label
      }
    end
  end
end
