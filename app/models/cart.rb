# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "session_id", "updated_at", "user_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["cart_items", "products", "user"]
  end
  
  def total
    cart_items.sum { |item| item.quantity * item.product.price }
  end
end
