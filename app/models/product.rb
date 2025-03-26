# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_one_attached :image
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end