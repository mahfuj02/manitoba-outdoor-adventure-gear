# app/models/order.rb
class Order < ApplicationRecord
    belongs_to :user
    belongs_to :shipping_address, class_name: 'Address', foreign_key: 'shipping_address_id'
    belongs_to :billing_address, class_name: 'Address', foreign_key: 'billing_address_id'
    
    has_many :order_items, dependent: :destroy
    has_many :products, through: :order_items
    
    validates :order_number, presence: true, uniqueness: true
    validates :status, presence: true
    
    enum status: { pending: 0, paid: 1, shipped: 2, delivered: 3, cancelled: 4 }
    
    before_validation :generate_order_number, on: :create
    
    def self.ransackable_attributes(auth_object = nil)
      ["billing_address_id", "created_at", "id", "order_date", "order_number", 
       "shipping_address_id", "shipping_cost", "status", "tax_amount", 
       "total_amount", "updated_at", "user_id"]
    end
    
    def self.ransackable_associations(auth_object = nil)
      ["billing_address", "order_items", "products", "shipping_address", "user"]
    end
    
    def subtotal
      order_items.sum(&:subtotal)
    end
    
    private
    
    def generate_order_number
      self.order_number ||= "ORD-#{Time.now.to_i}-#{SecureRandom.hex(3).upcase}"
    end
  end