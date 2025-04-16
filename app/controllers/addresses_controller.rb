# app/controllers/checkout_controller.rb - modified create_address method
def create_address
    # Check for either address_id or address with id
    if params[:address_id].present?
      @address = current_user.addresses.find(params[:address_id])
    elsif params[:address] && params[:address][:id].present? && !params[:address][:id].empty?
      @address = current_user.addresses.find(params[:address][:id])
    else
      @address = current_user.addresses.build
    end
    
    # Use the address params from the right parameter key
    if params[:address]
      @address.attributes = address_params
    end
    
    # Add more debug logging
    Rails.logger.debug "Address data: #{@address.attributes.inspect}"
    Rails.logger.debug "Form params: #{params.inspect}"
    
    if @address.save
      # Set as default if requested (checking both possible parameter formats)
      if params[:is_default] == "1" || params[:address][:is_default] == "1" || current_user.addresses.count == 1
        current_user.addresses.where.not(id: @address.id).update_all(is_default: false)
        @address.update(is_default: true)
      end
      
      redirect_to checkout_review_path
    else
      @provinces = Province.order(:name)
      @shipping_address = @address # Make sure we use the right variable name
      load_cart_items
      flash.now[:alert] = "There was a problem with your address: #{@address.errors.full_messages.join(', ')}"
      render :index
    end
  end
  
  # Updated address_params to accept is_default
  def address_params
    params.require(:address).permit(:street, :city, :province_id, :postal_code, :country, :is_default)
  end