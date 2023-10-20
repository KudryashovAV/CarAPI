class CarRankingTrackerJob < ActiveJob::Base
  queue_as :default

  def perform
    Cars::RankingTracker.call
  end
end
