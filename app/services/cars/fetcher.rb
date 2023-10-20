class Cars::Fetcher
  def self.call(car_params)
    sql = <<-SQL
      cars.id as id,
      cars.price as price,
      cars.model as model,
      brands.id as brand_id,
      brands.name as brand_name,
      car_rankings.rank_score as rank_score
    SQL

    scope = Car.left_joins(:car_rankings, brand: { preferred_brands: :user })
               .select(sql)
               .where(users: { id: [car_params[:user_id], nil] })

    scope = scope.where("brands.name LIKE ?", "%#{car_params[:query]}%") if car_params[:query]
    scope = scope.where("cars.price > ?", car_params[:price_min]) if car_params[:price_min]
    scope = scope.where("cars.price < ?", car_params[:price_max]) if car_params[:price_max]

    scope.order("rank_score DESC NULLS LAST, price ASC")
  end
end
