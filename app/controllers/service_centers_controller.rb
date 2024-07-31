class ServiceCentersController < ApplicationController
   before_action :set_service_owner, except: [:index]
  def index
    if params[:location].present?
      @service_centers = ServiceCenter.where('location ILIKE ?', "%#{params[:location]}%")
    else
      @service_centers = ServiceCenter.all
    end
  end

  def show
    @service_owner = ServiceOwner.find_by(id:params[:service_owner_id])
    @client_user = ClientUser.find_by(id: current_user.id) 
    @service_center = ServiceCenter.find_by(id:params[:id])
    @slots = @service_center.slots
    @user_slots = @service_center.slots.where(client_user_id: current_user.id) if current_user.role == 'client_user'
    @todays_revenue = Revenue.total_revenue_for_date(Date.today,@service_center.id)
    @this_months_revenue = Revenue.total_revenue_for_month(Date.today.year, Date.today.month, @service_center.id)
    # @bikes = @sevice_center.bikes
  end

  def search
    redirect_to service_centers_path(location: params[:location])
  end

  def new
    @service_center = @service_owner.service_centers.new
  end

  def edit
    @service_center = @service_owner.service_centers.find(params[:id])
  end

  def create
    @service_center = @service_owner.service_centers.create(service_center_params)
    if @service_center
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'Service Center was successfully created.'
    else
      render 'service_owners/index'
    end
  end

  def update
    @service_center = @service_owner.service_centers.find(params[:id])

    if @service_center.update(service_center_params)
      redirect_to service_owner_service_center_path(@service_owner, @service_center),
                  notice: 'Data updated successfully.'
    else
      render 'service_owners/index', status: :unprocessable_entity
    end
  end

  def destroy
    @service_center = @service_owner.service_centers.create(service_center_params)
  end

  private

  def set_service_owner
    @service_owner = ServiceOwner.find_by(id: params[:service_owner_id])
  end

  def service_center_params
    params.require(:service_center).permit(:name, :location, :total_slots)
  end
end
