class UsersController < ApplicationController
  def home
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

  def user_params
    params.require(:user).permit(:name, :email, :mobile, :password)
  end
end
