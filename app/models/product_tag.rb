# app/models/product_tag.rb
class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag
  
  # Ensure uniqueness of product-tag combination
  validates :product_id, uniqueness: { scope: :tag_id }
end