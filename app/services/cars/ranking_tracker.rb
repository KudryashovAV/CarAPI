module Cars
  class RankingTracker < RankingBase
    def self.call
      new.call
    end

    def call
      clear_all_records
      user_ids = fetch_user_ids
      car_rankings = []

      user_ids.each do |user_id|
        car_rankings << fetch_from_api_service(user_id).each { |record| record["user_id"] = user_id }
      end

      populate_data(car_rankings.flatten)
    end

    private

    def clear_all_records
      CarRanking.delete_all
    end

    def fetch_user_ids
      User.pluck(:id)
    end
  end
end
