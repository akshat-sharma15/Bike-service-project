class BookingsController < ApplicationController
  before_action :set_service_owner, except: :index
  before_action :set_service_center, except: :index
  before_action :set_bike, except: :index
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :confirm, :activate, :complete, :reject]

  def index
    @bookings = Booking.all
  end

  def show
    @service_center = ServiceCenter.find_by(id: params[:service_center_id])
    @booking = Booking.find_by(id: params[:id])
  end

  def new
    @booking = Booking.new
  end

  def edit
    @booking
  end

  def create
    @service_owner = ServiceOwner.find_by(id: params[:service_owner_id])
    @service_center = ServiceCenter.find_by(id: params[:service_center_id])
    @bike = Bike.find_by(id: params[:bike_id])
    @client_user = ClientUser.find_by(id: current_user.id)

    @booking = @bike.bookings.build(booking_params)
    @booking.service_center = @service_center
    @booking.client_user = @client_user
    @booking.status = 'pending'
    if @booking.save
      flash[:notice] = 'Booking was successfully added.'
      redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
    else
      redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
      flash.now[:alert] = @booking.errors.full_messages.to_sentence
    end
  end

  def update
    @booking
  end

  def confirm
    if @booking.confirm!
    redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
    else
    flash.now[:alert] = @booking.errors.full_messages
    render :show
    end
  end

  def activate
    @booking.activate!
    @booking.bike.rental!
    redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
  end

  def complete
    @booking.complete!
    @booking.bike.return!
    days = @booking.return_date - @booking.booking_date
    @booking.cost = @booking.bike.rate * days
    redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
  end

  def reject
    @booking.reject!
    redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
  end

  private

  def set_service_owner
    @service_owner = ServiceOwner.find(params[:service_owner_id])
  end

  def set_service_center
    @service_center = @service_owner.service_centers.find(params[:service_center_id])
  end

  def set_bike
    @bike = @service_center.bikes.find(params[:bike_id])
  end

  def set_booking
    @booking = @bike.bookings.find(params[:id])
  end 

  def booking_params
    params.require(:booking).permit(:booking_date, :return_date, :document, :service_center_id, :bike_id)
  end
end
