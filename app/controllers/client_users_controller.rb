class ClientUsersController < ApplicationController
  def index
    @client_user = ClientUser.find_by(id: current_user.id)
  end
end
