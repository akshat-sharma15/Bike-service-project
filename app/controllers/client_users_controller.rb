class ClientUsersController < ApplicationController
  def index
  end
  def show
    @client_user = ClientUser.find_by(id: current_user.id)
  end
end
