class BookingsController < ApplicationController
  before_action :set_service_owner, except: :index
  before_action :set_service_center, except: :index
  before_action :set_bike, except: :index
  before_action :set_booking, only: [:show, :update, :confirm, :activate, :complete, :reject]

  def index
    @bookings = Booking.all
  end

  def show
    @service_center = ServiceCenter.find_by(id: params[:service_center_id])
    @booking = Booking.find_by(id: params[:id])
  end

  def new
    @booking = @bike.bookings.build
  end

  def create
    @client_user = ClientUser.find_by(id: current_user.id)
    @service_center = ServiceCenter.find(params[:service_center_id])
    @bike = Bike.find(params[:bike_id])

    @booking = @bike.bookings.build(booking_params)
    @booking.service_center = @service_center
    @booking.client_user = @client_user

    if @booking.save
      flash[:notice] = 'Booking was successfully added.'
    else
      flash[:notice] = "#{@booking.errors.full_messages.to_s}"
    end
    redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
  end

  def update
    @booking
  end

  def confirm
    if @booking.confirm!
      flash[:notice] = 'Booking confirmed'
    else
      flash[:alert] = @booking.errors.full_messages.to_sentence.to_s
    end
    redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
  end

  def activate
    begin
      if @booking.booking_date == Date.today
        if @booking.bike.rental!
          begin
            @booking.activate!
            flash[:notice] = 'Booking Activated'
          rescue
            flash[:notice] = 'Booking not Activated check status of booking'
          end
        end
      else
        flash[:notice] = 'Booking is not for today'
      end
    rescue
      flash[:alert] = 'Booking not Activated check status of bike'
    end
    redirect_to service_owner_service_center_bike_path(@service_owner, @service_center, @bike)
  end

  def complete
    begin
      @booking.complete!
    rescue
      flash[:notice] = 'Booking not completed check status of booking'
    end

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
