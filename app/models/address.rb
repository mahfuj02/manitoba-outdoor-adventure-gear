# app/models/address.rb
class Address < ApplicationRecord
    belongs_to :user
    belongs_to :province
    
    validates :street, presence: true
    validates :city, presence: true
    validates :postal_code, presence: true
    validates :country, presence: true
    
    def self.ransackable_attributes(auth_object = nil)
      ["city", "country", "created_at", "id", "is_default", "postal_code", 
       "province_id", "street", "updated_at", "user_id"]
    end
    
    def self.ransackable_associations(auth_object = nil)
      ["province", "user"]
    end
    
    def full_address
      "#{street}, #{city}, #{province.code} #{postal_code}, #{country}"
    end
  end