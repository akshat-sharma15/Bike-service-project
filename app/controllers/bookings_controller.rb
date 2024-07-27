class BookingsController < ApplicationController
  def index
    @booking
  end

  def new
    @booking = Booking.new
  end

  def edit
    @booking
  end

  def create
    @booking = Booking.create(booking_params)
    if @booking
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'bike was successfully added.'
    else
      render 'service_owners/index'
    end
  end

  def update
    @booking
  end

  def destroy
    @booking
  end
end
