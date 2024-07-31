class BikesController < ApplicationController
  before_action :set_service_owner # , only: [:index, :create, :destroy, :show]
  before_action :set_service_center

  def index
    @bikes = Bike.all
  end

  def show
    @bike = @service_center.bikes.find(params[:id])
  end

  def new
    @bike = @service_center.bikes.new
  end

  def edit
    @bike = @service_center.bikes.find(params[:id])
  end

  def create
    @bike = @service_center.bikes.build(bike_params)
    if @bike.save
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
    @bike = Bike.find_by(id: params[:id])
    if @bike.present?
      @bike.need_full_service!
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to full service.'
    else
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state not updated.'
    end
  end

  def need_engine_service
    @bike = Bike.find_by(id: params[:id])
    if @bike.present?
      @bike.need_engine_service!
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to engine '
    else
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state not updated.'
    end
  end

  def need_wash_service
    @bike = Bike.find_by(id: params[:id])
    if @bike.present?
      @bike.need_wash_service!
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to wash service.'
    else
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state not updated.'
    end
  end

  def rental
    @bike = Bike.find_by(id: params[:id])
    if @bike.present?
      @bike.rental!
      @booking = Booking.with_booking_date(@bike.id).first
      @booking.status = 'active'
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to on rent.'
    else
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state not updated.'
    end
  end

  def return
    @bike = Bike.find_by(id: params[:id])
    if @bike.present?
      @bike.return!
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to returned.'
    else
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state not updated.'
    end
  end

  def avail
    @bike = Bike.find_by(id: params[:id])
    if @bike.present?
      @bike.avail!
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to available.'
    else
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state not updated.'
    end
  end

  def not_available
    if @bike.present?
      @bike = Bike.find_by(id:params[:id])
      @bike.not_available!
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state updated to not available.'
    else
      redirect_to service_owner_service_center_path(@service_owner, @service_center), notice: 'Bike state not updated.'
    end
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
