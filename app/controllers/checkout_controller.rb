# app/controllers/checkout_controller.rb
class CheckoutController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_cart_is_not_empty
    
    def index
      # Initialize or fetch addresses
      @shipping_address = current_user.addresses.find_by(is_default: true) || 
                          current_user.addresses.first || 
                          current_user.addresses.build
      @provinces = Province.order(:name)
    end
    
    def create_address
      @address = if params[:address_id].present?
                   current_user.addresses.find(params[:address_id])
                 else
                   current_user.addresses.build
                 end
      
      @address.attributes = address_params
      
      if @address.save
        # Set as default if requested or if it's the only address
        if params[:is_default] || current_user.addresses.count == 1
          current_user.addresses.update_all(is_default: false)
          @address.update(is_default: true)
        end
        
        redirect_to checkout_review_path
      else
        @provinces = Province.order(:name)
        flash.now[:alert] = "There was a problem with your address: #{@address.errors.full_messages.join(', ')}"
        render :index
      end
    end
    
    def review
      @cart = current_user.cart
      @shipping_address = current_user.addresses.find_by(is_default: true) || current_user.addresses.first
      
      if @shipping_address.nil?
        redirect_to checkout_path, alert: "Please add a shipping address before proceeding to checkout."
        return
      end
      
      @province = @shipping_address.province
      @cart_items = @cart.cart_items.includes(:product)
      
      # Calculate totals
      @subtotal = @cart.total
      @tax_amount = calculate_tax(@subtotal, @province)
      @total = @subtotal + @tax_amount
    end
    
    def complete
      @cart = current_user.cart
      @shipping_address = current_user.addresses.find_by(is_default: true) || current_user.addresses.first
      
      if @shipping_address.nil?
        redirect_to checkout_path, alert: "Please add a shipping address before placing an order."
        return
      end
      
      # Create the order
      @order = current_user.orders.build(
        order_date: Time.current,
        shipping_address_id: @shipping_address.id,
        billing_address_id: @shipping_address.id, # Using same address for billing
        status: :pending
      )
      
      # Calculate totals
      subtotal = @cart.total
      tax_amount = calculate_tax(subtotal, @shipping_address.province)
      total = subtotal + tax_amount
      
      @order.tax_amount = tax_amount
      @order.total_amount = total
      
      ActiveRecord::Base.transaction do
        if @order.save
          # Create order items from cart items
          @cart.cart_items.each do |cart_item|
            @order.order_items.create!(
              product: cart_item.product,
              quantity: cart_item.quantity,
              price_at_time_of_purchase: cart_item.product.price,
              subtotal: cart_item.quantity * cart_item.product.price
            )
          end
          
          # Clear the cart
          @cart.cart_items.destroy_all
          
          redirect_to order_path(@order), notice: "Order placed successfully!"
        else
          redirect_to checkout_review_path, alert: "There was a problem creating your order: #{@order.errors.full_messages.join(', ')}"
        end
      end
    end
    
    private
    
    def ensure_cart_is_not_empty
      if current_user.cart.nil? || current_user.cart.cart_items.empty?
        redirect_to root_path, alert: "Your cart is empty."
      end
    end
    
    def address_params
      params.require(:address).permit(:street, :city, :province_id, :postal_code, :country)
    end
    
    def calculate_tax(amount, province)
      return 0 unless province
      tax_rate = province.tax_rate
      (amount * tax_rate / 100).round(2)
    end
  end