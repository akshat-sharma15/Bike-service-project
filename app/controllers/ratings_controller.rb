class RatingsController < ApplicationController
  def index
    @service_center = ServiceCenter.find_by(id: params[:id])
    @ratings = @service_center.ratings
  end

  def create
    @rate = @service_center.ratings.create(rating_params)
  end

  private

  def rating_params
    params.require(:rateing).permit(:star, :comments)
  end
end
