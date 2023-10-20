module Cars
  class RankingFetcher < RankingBase
    def self.call(user_id)
      new(user_id).call
    end

    def initialize(user_id)
      @user_id = user_id
    end

    attr_reader :user_id

    def call
      database_data = fetch_from_database(user_id)

      database_data.blank? ? populate_and_return(user_id) : database_data
    end

    private

    def fetch_from_database(user_id)
      CarRanking.where(user_id: user_id).where("updated_at > ?", Time.current.beginning_of_day)
    end

    def populate_and_return(user_id)
      data = fetch_from_api_service(user_id).each { |record| record["user_id"] = user_id }

      populate_data(data)
    end
  end
end
