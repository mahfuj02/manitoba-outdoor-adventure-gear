# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_one_attached :image

  has_many :cart_items
  has_many :carts, through: :cart_items

  has_many :product_tags, dependent: :destroy
  has_many :tags, through: :product_tags
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where(is_new: true) }
  scope :recently_updated, -> { order(updated_at: :desc).limit(10) }
  
  # Helper method to check if a product is on sale with a valid sale price
  def on_sale?
    on_sale && sale_price.present? && sale_price < price
  end

  # Helper method to check if a product is new
  def is_new?
    is_new || created_at >= 2.weeks.ago
  end

  # Calculate discount percentage for products on sale
  def discount_percentage
    return 0 unless on_sale?
    ((price - sale_price) / price * 100).round
  end

  # Get the current display price (sale price or regular price)
  def current_price
    on_sale? ? sale_price : price
  end
  
  # Define which attributes can be searchable through Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "dimensions", "id", "is_new", "name", 
     "on_sale", "price", "sale_price", "sku", "stock_quantity", "updated_at", "weight"]
  end
  
  # Define which associations can be searchable through Ransack
  def self.ransackable_associations(auth_object = nil)
    ["category", "cart_items", "carts", "image_attachment", "image_blob", "product_tags", "tags"]
  end
end