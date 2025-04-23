# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  
  # Define ransackable attributes for ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", 
     "reset_password_sent_at", "reset_password_token", "updated_at", "current_sign_in_at", 
     "sign_in_count"]
  end
  
  # Define ransackable associations for ActiveAdmin
  def self.ransackable_associations(auth_object = nil)
    []
  end
end