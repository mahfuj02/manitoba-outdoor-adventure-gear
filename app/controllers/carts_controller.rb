# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :initialize_cart
  
  def show
    @cart_items = @cart.cart_items.includes(:product)
  end
  
  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i || 1
    
    # Find or initialize a new cart item
    cart_item = @cart.cart_items.find_by(product: product)
    
    if cart_item
      # Update quantity if item exists
      cart_item.update(quantity: cart_item.quantity + quantity)
    else
      # Create new cart item if it doesn't exist
      cart_item = @cart.cart_items.create(product: product, quantity: quantity)
    end
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: products_path, notice: "#{product.name} added to cart.") }
      format.json { render json: { status: 'success', message: "#{product.name} added to cart." } }
    end
  end
  
  def update_item
    cart_item = @cart.cart_items.find(params[:id])
    quantity = params[:quantity].to_i
    
    if quantity <= 0
      cart_item.destroy
      notice = "Item removed from cart."
    else
      cart_item.update(quantity: quantity)
      notice = "Cart updated successfully."
    end
    
    redirect_to cart_path, notice: notice
  end
  
  def remove_item
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    
    redirect_to cart_path, notice: "Item removed from cart."
  end
  
  private
  
  def initialize_cart
    if user_signed_in?
      # Find or create cart for logged in user
      @cart = current_user.cart || current_user.create_cart
    else
      # Find or create cart based on session
      session[:cart_id] ||= SecureRandom.hex(16)
      @cart = Cart.find_or_create_by(session_id: session[:cart_id])
    end
  end
end