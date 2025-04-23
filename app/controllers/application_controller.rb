# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :initialize_cart
  
  private
  
  
  helper_method :current_cart
  
  def current_cart
    if user_signed_in?
      # Create a cart for the user if they don't have one
      if current_user.cart.nil?
        current_user.create_cart
      end
      current_user.cart
    else
      # For guests, use session-based cart
      cart = Cart.find_by(id: session[:cart_id])
      
      # If no cart in session or cart not found, create a new one
      if cart.nil?
        cart = Cart.create
        session[:cart_id] = cart.id
      end
      
      cart
    end
  end
  def initialize_cart
    session[:cart] ||= {}
    
    @cart_count = session[:cart].values.sum
    
    # Load mini cart data for all views
    @mini_cart_items = []
    @mini_cart_total = 0
    
    if session[:cart].present?
      session[:cart].each do |product_id, quantity|
        product = Product.find_by(id: product_id)
        next unless product
        
        item_price = product.on_sale && product.sale_price.present? ? product.sale_price : product.price
        item_total = item_price * quantity
        
        @mini_cart_items << {
          product: product,
          quantity: quantity,
          price: item_price,
          total: item_total
        }
        
        @mini_cart_total += item_total
      end
    end
  end
end