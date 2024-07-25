class ServiceOwnersController < ApplicationController
  before_action :set_service_owner 
  def index
    @service_owner
  end 

  def add_service_center
    @service_owner.service_centers.create(service_center_params)
  end

  def show
    @service_owner
  end

  def edit
    @service_owner
  end

  def update
    @service_owner
  end

  private

  def service_center_params
    params.require(:service_center).permit(:name, :location)
  end

  def set_service_owner
    @service_owner ||= ServiceOwner.find_by(id: current_user.id)
  end
end
