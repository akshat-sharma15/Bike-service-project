class ServiceOwnersController < ApplicationController
  # before_action  :set_user, only: [:add_service_center, :index]
  def index 
    @service_owner = current_user
  end 

  def add_service_center
    @service_owner.service_centers.create(service_center_params)
  end

  private
  def service_center_params
    params.require(:service_center).permit(:name, :location)
  end

  def set_user
    @service_owner = current_user
  end
end
