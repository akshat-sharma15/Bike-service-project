class UsersController < ApplicationController
  before_action :set_service_owner 
  before_action :set_client_user
  before_action :set_admin

  def home
    @client_user
  end

  def index
    @user = current_user
  end

  def show 
    @user = current_user
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create 
    @user = User.new(user_params)
    if @user.save
        redirect_to @user
    else
        render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def set_service_owner
    @service_owner ||= ServiceOwner.find_by(id: current_user.id) if user_signed_in?
  end

  def set_client_user
    @client_user ||= ClientUser.find_by(id: current_user.id) if user_signed_in?
  end

  def set_admin
    @admin ||= Admin.find_by(id: current_user) if user_signed_in?
  end

  def user_params
    params.require(:user).permit(:name, :email, :mobile, :password)
  end
end
