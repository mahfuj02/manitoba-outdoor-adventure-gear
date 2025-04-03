# app/models/category.rb
class Category < ApplicationRecord
    has_many :products
    
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
    
    # Define which attributes can be searchable through Ransack
    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "description", "id", "name", "updated_at"]
    end
    
    # Define which associations can be searchable through Ransack
    def self.ransackable_associations(auth_object = nil)
      ["products"]
    end
  end