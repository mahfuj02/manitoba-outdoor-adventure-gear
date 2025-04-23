# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

     # GET /resource/sign_up
    def new
      super do |resource|
        @provinces = Province.order(:name)
        resource.addresses.build if resource.addresses.empty?
      end
    end

  # POST /resource
    def create
      super do |resource|
        if resource.persisted? && params[:address].present?
          address = resource.addresses.build(address_params)
          address.is_default = true
          address.save
        end
      end
    end
  
    protected
  
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone])
    end
  
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone])
    end

    private

    def address_params
      params.require(:address).permit(:street, :city, :province_id, :postal_code, :country)
    end
  end