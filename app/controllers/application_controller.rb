class ApplicationController < ActionController::Base
  # skip_before_action :authenticate_user!, only: [:sign_in]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :log_flash_contents

  # protected
  def log_flash_contents
    Rails.logger.info "FLASH: #{flash.to_hash.inspect}"
  end

  def set_current_user
    case resource.role
    when 'service_owner'
      ServiceOwner.find_by(email: resource.email)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    # devise_parameter_sanitizer.permit(:account_update, keys: [:name, role])
  end
end
