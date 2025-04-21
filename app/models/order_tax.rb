# app/models/order_tax.rb
class OrderTax < ApplicationRecord
    belongs_to :order
    
    validates :gst_rate, numericality: { greater_than_or_equal_to: 0 }
    validates :pst_rate, numericality: { greater_than_or_equal_to: 0 }
    validates :hst_rate, numericality: { greater_than_or_equal_to: 0 }
    validates :gst_amount, numericality: { greater_than_or_equal_to: 0 }
    validates :pst_amount, numericality: { greater_than_or_equal_to: 0 }
    validates :hst_amount, numericality: { greater_than_or_equal_to: 0 }
    
    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "gst_amount", "gst_rate", "hst_amount", "hst_rate", 
       "id", "order_id", "pst_amount", "pst_rate", "updated_at"]
    end
    
    def self.ransackable_associations(auth_object = nil)
      ["order"]
    end
    
    def total_tax_amount
      gst_amount + pst_amount + hst_amount
    end
  end