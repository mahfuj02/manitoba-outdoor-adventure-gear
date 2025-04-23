# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    @featured_products = Product.order(created_at: :desc).limit(2)
    @new_products = Product.where(is_new: true).order(created_at: :desc).limit(8)
    @sale_products = Product.where(on_sale: true).order(created_at: :desc).limit(8)
  end
end