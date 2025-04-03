# app/models/contact_page.rb
class ContactPage < ApplicationRecord
    validates :content, presence: true
    
    def self.ransackable_attributes(auth_object = nil)
      ["content", "created_at", "id", "id_value", "updated_at"]
    end
    
    def self.ransackable_associations(auth_object = nil)
      []
    end
  end