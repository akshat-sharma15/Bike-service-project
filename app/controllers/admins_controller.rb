class AdminsController < ApplicationController
  def home
    @admin = Admin.find_by(id: current_user.id)
  end
  def index 
    @user = current_user
  end 
end
