class ForeignApi :: UserRecommendedCarsController < ApplicationController

  def index
    render json: ForeignServices::UserRecommendedCarsApi.call(records, user_cars_params[:user_id])
  end

  private

  def user_cars_params
    params.permit(:user_id)
  end
end
