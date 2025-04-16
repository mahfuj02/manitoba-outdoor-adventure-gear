# app/models/province.rb
class Province < ApplicationRecord
    has_many :addresses
    
    validates :name, presence: true
    validates :code, presence: true
    validates :gst, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :pst, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :hst, presence: true, numericality: { greater_than_or_equal_to: 0 }
    
    def self.ransackable_attributes(auth_object = nil)
      ["code", "created_at", "gst", "hst", "id", "name", "pst", "updated_at"]
    end
    
    def self.ransackable_associations(auth_object = nil)
      ["addresses"]
    end
    
    def display_name
      "#{name} (#{code})"
    end
    
    def tax_rate
      gst + pst + hst
    end
  end