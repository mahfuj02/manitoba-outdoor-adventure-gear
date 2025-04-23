# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  def show
    load_cart_items
  end
  
  def add_item
    # The error is happening here - params[:id] is nil, but we're getting product_id
    product_id = params[:product_id] || params[:id]
    
    # Ensure we have a product ID
    if product_id.blank?
      flash[:alert] = "Product not found"
      redirect_back(fallback_location: products_path)
      return
    end
    
    # Find the product
    @product = Product.find(product_id)
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1
    
    # Initialize cart in session if it doesn't exist
    session[:cart] ||= {}
    
    # Convert ID to string for consistent hash key
    product_id = product_id.to_s
    
    # Add to cart
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += quantity
    
    # Force session save
    session[:updated_at] = Time.now.to_i
    
    flash[:notice] = "#{@product.name} added to your cart."
    redirect_to cart_path
  end
  
  def update_item
    product_id = params[:id].to_s
    quantity = params[:quantity].to_i
    
    # Get the cart from session
    session[:cart] ||= {}
    
    if quantity <= 0
      # Remove item if quantity is zero or negative
      session[:cart].delete(product_id)
      flash[:notice] = "Item removed from cart."
    else
      # Update quantity
      session[:cart][product_id] = quantity
      flash[:notice] = "Cart updated successfully."
    end
    
    # Force session save
    session[:updated_at] = Time.now.to_i
    
    redirect_to cart_path
  end
  
  def remove_item
    product_id = params[:id].to_s
    
    # Get the cart from session
    session[:cart] ||= {}
    
    # Remove item
    session[:cart].delete(product_id)
    
    # Force session save
    session[:updated_at] = Time.now.to_i
    
    flash[:notice] = "Item removed from cart."
    redirect_to cart_path
  end
  
  private
  
  def load_cart_items
    @cart_items = []
    @total = 0
    
    if session[:cart].present?
      Rails.logger.debug "Cart from session: #{session[:cart].inspect}"
      
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
    else
      Rails.logger.debug "Cart is empty or not present in session"
    end
  end
end