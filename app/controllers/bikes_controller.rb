class BikesController < ApplicationController
  before_action :set_service_owner # , only: [:index, :create, :destroy, :show]
  before_action :set_service_center

  def index
    @bikes = Bike.all
  end

  def show
    @service_owner
    @service_center
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

  def need_full_service
    @bike = Bike.find_by(id:params[:id])
    @bike.need_full_service!
    redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to full service.'
  end

  def need_engine_service
    @bike = Bike.find_by(id:params[:id])
    @bike.need_engine_service!
    redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to engine service.'
  end

  def need_wash_service
    @bike = Bike.find_by(id:params[:id])
    @bike.need_wash_service!
    redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to wash service.'
  end

  def rental
    @bike = Bike.find_by(id:params[:id])
    @bike.rental!
    @booking = Booking.with_booking_date(@bike.id).first
    @booking.status = 'active'
    redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to on rent.'
  end

  def return
    @bike = Bike.find_by(id:params[:id])
    @bike.return!
    redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to returned.'
  end

  def avail
    @bike = Bike.find_by(id:params[:id])
    @bike.avail!
    redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to available.'
  end

  def not_available
    @bike = Bike.find_by(id:params[:id])
    @bike.not_available!
    redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to not available.'
  end


  private

  def set_service_owner
    @service_owner = ServiceOwner.find_by(id: params[:service_owner_id])
  end

  def set_service_center
    @service_center = @service_owner.service_centers.find_by(id: params[:service_center_id]) if @service_owner
  end

  def set_bike
    @bike = @service_center.bikes.find(params[:id]) if @service_center
  end

  def bike_params
    params.require(:bike).permit(:info, :regstration_num, :status, :avatar, :rent)
  end
end
