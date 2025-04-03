# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def index
    @products = Product.all
    
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
      @category = Category.find(params[:category_id])
    end
  end
  
  def show
    @product = Product.find(params[:id])
  end
end