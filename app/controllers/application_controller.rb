class ApplicationController < ActionController::Base
  # skip_before_action :authenticate_user!, only: [:sign_in]

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :log_flash_contents

  begin
  before_action :authenticate_user!

  rescue 
    handle_session_expiry
  end
  # protected
  def log_flash_contents
    Rails.logger.info "FLASH: #{flash.to_hash.inspect}"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    # devise_parameter_sanitizer.permit(:account_update, keys: [:name, role])
  end

  private

  def handle_session_expiry
    flash[:alert] = "Your session has expired. Please log in again."
    redirect_to 'app/home'
  end
end
