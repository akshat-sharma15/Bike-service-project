class BikesController < ApplicationController
  before_action :set_service_owner # , only: [:index, :create, :destroy, :show]
  before_action :set_service_center

  def index
    @service_centers = @service_owner.service_centers.find(params[:id])
    @bikes = @service_center.bikes
  end

  def show
    @service_center = @service_owner.service_centers.find(params[:id])
    @bike = @service_center.bikes.find(params[:id])
  end

  def new
    @bike = @service_center.bikes.new
  end

  def edit
    @bike = @service_center.bikes.find(params[:id])
  end

  def create
    @bike = @service_center.bikes.create(bike_params)
    if @bike
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'bike was successfully added.'
    else
      render 'service_owners/index'
    end
  end

  def update
    @bike = @service_center.bikes.find(params[:id])

    if @bike.update(service_center_params)
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'Data updated successfully.'
    else
      render 'service_owners/index', status: :unprocessable_entity
    end
  end

  def destroy
    @bike
  end

  private

  def set_service_center
    @service_center = @service_owner.service_centers.find_by(id: params[:service_center_id])
  end

  def set_service_owner
    @service_owner = ServiceOwner.find_by(id: params[:service_owner_id])
  end

  def bike_params
    params.require(:bike).permit(:info, :regstration_num, :status, :avatar)
  end
end
