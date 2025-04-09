# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_one_attached :image

  has_many :cart_items
  has_many :carts, through: :cart_items
  
  validates :name, presence: true
  validates :description, presence: true
  # Update this line to fix the validation error
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where(is_new: true) }
  scope :recently_updated, -> { order(updated_at: :desc).limit(10) }
  
  # Define which attributes can be searchable through Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "dimensions", "id", "is_new", "name", 
     "on_sale", "price", "sale_price", "sku", "stock_quantity", "updated_at", "weight"]
  end
  
  # Define which associations can be searchable through Ransack
  def self.ransackable_associations(auth_object = nil)
    ["category", "image_attachment", "image_blob"]
  end

  
end