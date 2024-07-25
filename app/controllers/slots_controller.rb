class SlotsController < ApplicationController
  before_action :set_service_owner
  before_action :set_service_center

  def index
    @service_owner
  end

  def show
    @service_owner
  end

  def edit
    @service_owner
  end

  def create
    @service_owner = ServiceOwner.find_by(id: current_user.id)
    @service_center = @service_owner.service_centers.find(params[:id])
    @slot = @service_center.create(slot_params)
  end

  def update
    @service_owner
  end

  private

  def set_service_owner
    @service_owner = ServiceOwner.find_by(id: current_user.id)
  end

  def slot_params
    params.require(:slot).permit(:status, :type, :booking_date, :time)
  end
end
