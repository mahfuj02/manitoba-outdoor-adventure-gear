class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
  def subtotal
    product.price * quantity
  end
end

# app/models/user.rb (update to add cart association)
class User < ApplicationRecord
  # Keep existing code
  # ...
  
  has_one :cart, dependent: :destroy
end