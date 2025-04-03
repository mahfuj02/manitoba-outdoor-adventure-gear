# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    @products = Product.all
    
    # Handle category filter
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @category = Category.find(params[:category_id])
    end
    
    # Handle other filters
    @products = @products.on_sale if params[:filter] == 'on_sale'
    @products = @products.new_products if params[:filter] == 'new'
    @products = @products.recently_updated if params[:filter] == 'recently_updated'
    
    # Set filter name for display
    @filter_name = case params[:filter]
                   when 'on_sale' then 'On Sale'
                   when 'new' then 'New Arrivals'
                   when 'recently_updated' then 'Recently Updated'
                   else nil
                   end
    
    # Apply pagination
    @products = @products.page(params[:page]).per(9)
  end
  
  def show
    @product = Product.find(params[:id])
  end
end