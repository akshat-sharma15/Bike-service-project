# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, only: [:sign_in]

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  
  # def after_sign_in_path_for(resource)
  #   case resource.role
  #   when 'user_client'
  #     user_index_path 
  #   when 'service_owner'
  #     service_owner_index_path 
  #   when 'admin'
  #     admin_index_path
  #   else
  #     root_path
  #   end
  # end
end
