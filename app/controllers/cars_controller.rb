class CarsController < ApplicationController
  include Pagy::Backend

  def index
    if car_params[:user_id].blank?
      render json: { error: "'user_id' parameter is required" }, status: :bad_request
      return
    end

    Cars::RankingFetcher.call(car_params[:user_id])

    _, records = pagy(Cars::Fetcher.call(car_params.to_h), page: car_params[:page])

    render json: Cars::ResponseBuilder.call(records, car_params[:user_id])
  end

  private

  def car_params
    params.permit(:user_id, :query, :price_min, :price_max, :page)
  end
end
