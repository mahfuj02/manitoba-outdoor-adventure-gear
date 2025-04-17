# app/controllers/addresses_controller.rb
class AddressesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_address, only: [:show, :edit, :update, :destroy, :set_default]
    
    def index
      @addresses = current_user.addresses
      @address = Address.new
      @provinces = Province.order(:name)
    end
    
    def show
      # This action might not be needed, but adding it to resolve the error
      redirect_to addresses_path
    end
    
    def new
      @address = current_user.addresses.build
      @provinces = Province.order(:name)
    end
    
    def create
      @address = current_user.addresses.build(address_params)
      
      if @address.save
        # Set as default if requested or if it's the only address
        if params[:address][:is_default] == "1" || current_user.addresses.count == 1
          current_user.addresses.update_all(is_default: false)
          @address.update(is_default: true)
        end
        
        redirect_to addresses_path, notice: 'Address was successfully created.'
      else
        @addresses = current_user.addresses
        @provinces = Province.order(:name)
        render :index
      end
    end
    
    def edit
      @provinces = Province.order(:name)
    end
    
    def update
      if @address.update(address_params)
        # Set as default if requested
        if params[:address][:is_default] == "1"
          current_user.addresses.where.not(id: @address.id).update_all(is_default: false)
          @address.update(is_default: true)
        end
        
        redirect_to addresses_path, notice: 'Address was successfully updated.'
      else
        @provinces = Province.order(:name)
        render :edit
      end
    end
    
    def destroy
      @address.destroy
      
      # If we deleted the default address, make another one default
      if @address.is_default? && current_user.addresses.exists?
        current_user.addresses.first.update(is_default: true)
      end
      
      redirect_to addresses_path, notice: 'Address was successfully deleted.'
    end
    
    def set_default
      current_user.addresses.update_all(is_default: false)
      @address.update(is_default: true)
      
      redirect_to addresses_path, notice: 'Default address updated.'
    end
    
    private
    
    def set_address
      @address = current_user.addresses.find(params[:id])
    end
    
    def address_params
      params.require(:address).permit(:street, :city, :province_id, :postal_code, :country, :is_default)
    end
  end