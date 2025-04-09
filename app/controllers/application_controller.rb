# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :initialize_cart
  
  private
  
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