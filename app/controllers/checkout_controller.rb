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
    
    # Load cart items for the order summary
    load_cart_items
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
      load_cart_items
      flash.now[:alert] = "There was a problem with your address: #{@address.errors.full_messages.join(', ')}"
      render :index
    end
  end
  
  def review
    @shipping_address = current_user.addresses.find_by(is_default: true) || current_user.addresses.first
    
    if @shipping_address.nil?
      redirect_to checkout_path, alert: "Please add a shipping address before proceeding to checkout."
      return
    end
    
    @province = @shipping_address.province
    load_cart_items
    
    # Calculate tax
    @tax_amount = calculate_tax(@total, @province)
    @grand_total = @total + @tax_amount
  end
  
  def complete
    @shipping_address = current_user.addresses.find_by(is_default: true) || current_user.addresses.first
    
    if @shipping_address.nil?
      redirect_to checkout_path, alert: "Please add a shipping address before placing an order."
      return
    end
    
    load_cart_items
    
    # Calculate tax
    @tax_amount = calculate_tax(@total, @shipping_address.province)
    @grand_total = @total + @tax_amount
    
    # Create the order
    @order = current_user.orders.build(
      order_date: Time.current,
      shipping_address_id: @shipping_address.id,
      billing_address_id: @shipping_address.id, # Using same address for billing
      status: :pending,
      order_number: "ORD-#{Time.now.to_i}#{current_user.id}",
      tax_amount: @tax_amount,
      total_amount: @grand_total
    )
    
    ActiveRecord::Base.transaction do
      if @order.save
        # Create order items from cart items
        @cart_items.each do |item|
          @order.order_items.create!(
            product: item[:product],
            quantity: item[:quantity],
            price_at_time_of_purchase: item[:price],
            subtotal: item[:total]
          )
        end
        
        # Clear the cart
        session[:cart] = {}
        session[:updated_at] = Time.now.to_i
        
        redirect_to order_path(@order), notice: "Order placed successfully!"
      else
        redirect_to checkout_review_path, alert: "There was a problem creating your order: #{@order.errors.full_messages.join(', ')}"
      end
    end
  end
  
  private
  
  def ensure_cart_is_not_empty
    if session[:cart].blank? || session[:cart].empty?
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
  
  def load_cart_items
    @cart_items = []
    @total = 0
    
    if session[:cart].present?
      session[:cart].each do |product_id, quantity|
        product = Product.find_by(id: product_id)
        next unless product
        
        item_price = product.on_sale && product.sale_price.present? ? product.sale_price : product.price
        item_total = item_price * quantity
        
        @cart_items << {
          product: product,
          quantity: quantity,
          price: item_price,
          total: item_total
        }
        
        @total += item_total
      end
    end
  end
end