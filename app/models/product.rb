# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_one_attached :image
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  # Define which attributes can be searchable through Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "dimensions", "id", "name", "price", "sku", "stock_quantity", "updated_at", "weight"]
  end
  
  # Define which associations can be searchable through Ransack
  def self.ransackable_associations(auth_object = nil)
    ["category", "image_attachment", "image_blob"]
  end
end