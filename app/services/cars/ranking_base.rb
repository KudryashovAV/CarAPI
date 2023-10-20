require "net/https"

class Cars::RankingBase
  def fetch_from_api_service(user_id)
    uri = URI("https://bravado-images-production.s3.amazonaws.com/recomended_cars.json?user_id=#{user_id}")
    http = Net::HTTP.start(uri.host, uri.port, use_ssl: true)
    request = Net::HTTP::Get.new(uri.path, { "Content-Type" => "application/json" })
    http.max_retries = 3
    response = http.request(request)
    http.finish if http.started?

    response.code == "200" ? JSON.parse(response.body) : []
  end

  def populate_data(data)
    CarRanking.insert_all(data, returning: [:rank_score, :user_id, :car_id])
  end
end
