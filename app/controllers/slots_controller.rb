class SlotsController < ApplicationController
  before_action :set_service_owner
  before_action :set_service_center

  def index
    @service_owner
  end

  def show
    @slot = @service_center.slots.find_by(id: params[:id])
  end

  def new
    @slot = @service_center.slots.new
  end

  def edit
    @service_owner
  end

  def create
    @slot = @service_center.slots.build(slot_params)
    @slot.client_user_id = current_user.id
    @slot.status = 'pending'
    case @slot.service_type
    when 'Full Service'
      @slot.cost = 1000.00
    when 'Engine Service'
      @slot.cost = 500.00
    when 'Wash Service'
      @slot.cost = 200.00
    else
      @slot.cost = -1.00
    end

    if @slot.save
      redirect_to service_owner_service_center_path(@service_center.service_owner, @service_center), notice: 'Service Center was successfully created.'
    else
      puts"not done", notice: 'Service Center was not created.'
    end
  end

  def update
    @service_owner
  end

  private

  def set_service_center
    @service_center = @service_owner.service_centers.find_by(id: params[:service_center_id])
  end

  def set_service_owner
    @service_owner = ServiceOwner.find_by(id: params[:service_owner_id])
  end

  def slot_params
    params.require(:slot).permit(:service_type, :booking_date, :time, :status)
  end
end
