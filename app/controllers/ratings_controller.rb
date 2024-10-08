class RatingsController < ApplicationController
  def index
    @service_center = ServiceCenter.find_by(id: params[:service_center_id])
    @ratings = @service_center.ratings
  end

  def new
    @service_center = ServiceCenter.find_by(id: params[:service_center_id])
    @rate = @service_center.ratings.new
  end

  def edit
    @service_owner
  end

  def create
    @service_owner = ServiceOwner.find_by(id: params[:service_owner_id])
    @service_center = ServiceCenter.find_by(id: params[:service_center_id])
    @rate = @service_center.ratings.build(rating_params)
    @rate.client_user_id = ClientUser.find_by(id: current_user.id).id
    if @rate.save
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'Rating was successfully added.'
    else
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'Rating was not added.'
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:star, :comments)
  end
end
