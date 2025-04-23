# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Associations
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_one :cart, dependent: :destroy
  
  # Helper method
  def full_name
    "#{first_name} #{last_name}"
  end
  
  # Define ransackable attributes for ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "first_name", "id", "last_name", 
     "phone", "remember_created_at", "reset_password_sent_at", "reset_password_token", 
     "updated_at"]
  end
  
  # Define ransackable associations for ActiveAdmin
  def self.ransackable_associations(auth_object = nil)
    ["addresses", "cart", "orders", "reviews"]
  end
end