# app/models/order_item.rb
class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :product
    
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :price_at_time_of_purchase, presence: true, numericality: { greater_than: 0 }
    
    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "order_id", "price_at_time_of_purchase", "product_id", 
       "quantity", "subtotal", "updated_at"]
    end
    
    def self.ransackable_associations(auth_object = nil)
      ["order", "product"]
    end
    
    def subtotal
      quantity * price_at_time_of_purchase
    end
  end