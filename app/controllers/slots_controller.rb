class SlotsController < ApplicationController
  before_action :set_service_owner, except: [:index]
  before_action :set_service_center, except: [:index]
  before_action :set_slot, except: [:index]

  def index
    @slots = Slot.all
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
    @slot = @service_center.slots.build(slot_params.merge(client_user_id: current_user.id))
    if @slot.save
      flash[notice:] = 'Slot was successfully created. its under rewiew Check status after some time for updates'
    else
      flash[notice:] = @slot.errors.full_messages
    end
    redirect_to service_owner_service_center_path(@service_center.service_owner, @service_center)
  end

  def update
    @service_owner
  end

  def confirm
    if @slot.confirm!
      flash[:notice] = 'Slot confirmed!'
    else
      flash[:alert] = 'Slot could not be confirmed.'
    end

    redirect_to service_owner_service_center_slot_path(@service_owner, @service_center, @slot)
  end

  def service
    if @slot.service!
      flash[:notice] = 'Slot is now on service!'
    else
      flash[:alert] = 'Slot could not be started.'
    end

    redirect_to service_owner_service_center_slot_path(@service_owner, @service_center, @slot)
  end

  def complete
    if @slot.complete!
      flash[:notice] = 'Slot completed!'
      if @slot.client_user.email.match?(URI::MailTo::EMAIL_REGEXP)
        begin
          UserMailer.bill_mail(@slot.client_user).deliver_now
        rescue 
          flash[:alert] = 'Failed to send email due to an error.'
        end
      else
        flash[:alert] = 'Invalid email address to send bill.'
      end
    else
      flash[:alert] = 'Slot could not be completed.'
    end

    redirect_to service_owner_service_center_slot_path(@service_owner, @service_center, @slot)
  end

  def reject
    if @slot.reject!
      flash[:notice] = 'Slot rejected!'
      begin
        UserMailer.reject_mail(@slot.client_user).deliver_now
      rescue 
        flash[:alert] = 'Failed to send email due to an error.'
      end
    else
      flash[:alert] = 'Slot could not be rejected.'
    end

    redirect_to service_owner_service_center_slot_path(@service_owner, @service_center, @slot)
  end

  def waits
    if @slot.waits!
      flash[:notice] = 'Slot is now waiting!'
    else
      flash[:alert] = 'Slot could not be put on waiting.'
    end

    redirect_to service_owner_service_center_slot_path(@service_owner, @service_center, @slot)
  end

  def reset
    if @slot.reset!
      flash[:notice] = 'Slot reset to pending!'
    else
      flash[:alert] = 'Slot could not be reset.'
    end

    redirect_to service_owner_service_center_slot_path(@service_owner, @service_center, @slot)
  end

  def cancle
    if Date.today + 2 >= Date.parse(@slot.booking_date)
      flash[:notice] = 'You cannot cancle booking 2 days before the date.'
    elsif @slot.status == 'on_service'
      flash[:notice] = 'Can not cancle booking service started.'
    else
      flash[:notice] = 'Slot  cancelled'
    end

    redirect_to service_owner_service_center_slot_path(@service_owner, @service_center, @slot)
  end

  private

  def set_service_center
    @service_center = @service_owner.service_centers.find_by(id: params[:service_center_id])
  end

  def set_service_owner
    @service_owner = ServiceOwner.find_by(id: params[:service_owner_id])
  end

  def set_slot
    @slot = @service_center.slots.find_by(id: params[:id])
  end

  def slot_params
    params.require(:slot).permit(:service_type, :booking_date, :time, :status)
  end
end
