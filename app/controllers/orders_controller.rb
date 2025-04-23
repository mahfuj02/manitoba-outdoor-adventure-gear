# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [:show]
    
    def index
      @orders = current_user.orders.order(created_at: :desc)
    end
    
    def show
      # Make sure users can only see their own orders
      unless @order.user == current_user
        redirect_to orders_path, alert: "You are not authorized to view this order."
        return
      end
    end
    
    private
    
    def set_order
      @order = Order.find(params[:id])
    end
  end