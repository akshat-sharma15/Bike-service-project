class ServiceCentersController < ApplicationController
  before_action :set_service_owner # , only: [:index, :create, :destroy, :show]

  def index
    @service_centers = ServiceCenter.all
  end

  def show
    @service_center = @service_owner.service_centers.find(params[:id])
    @slots = @service_center.slots
    # @bikes = @sevice_center.bikes
  end

  def new
    @service_center = @service_owner.service_centers.new
  end

  def edit
    @service_center = @service_owner.service_centers.find(params[:id])
  end

  def create
    @service_center = @service_owner.service_centers.create(service_center_params)
    if @service_center
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'Service Center was successfully created.'
    else
      render 'service_owners/index'
    end
  end

  def update
    @service_center = @service_owner.service_centers.find(params[:id])

    if @service_center.update(service_center_params)
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'Data updated successfully.'
    else
      render 'service_owners/index', status: :unprocessable_entity
    end
  end

  def destroy
    @service_center = @service_owner.service_centers.create(service_center_params)
  end
  
  private

  def set_service_owner
    @service_owner = ServiceOwner.find_by(id: params[:service_owner_id])
  end

  def service_center_params
    params.require(:service_center).permit(:name, :location)
  end
end
