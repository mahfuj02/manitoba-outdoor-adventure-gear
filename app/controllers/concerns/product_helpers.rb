# app/models/concerns/product_helpers.rb
# Add these methods to your Product model

# You can add these methods directly to your Product model class, 
# or create this concern and include it in your Product model

module ProductHelpers
    extend ActiveSupport::Concern
  
    # Helper method to check if a product is on sale with a valid sale price
    def on_sale?
      on_sale && sale_price.present? && sale_price < price
    end
  
    # Helper method to check if a product is new
    def is_new?
      is_new || created_at >= 2.weeks.ago
    end
  
    # Calculate discount percentage for products on sale
    def discount_percentage
      return 0 unless on_sale?
      ((price - sale_price) / price * 100).round
    end
  
    # Get the current display price (sale price or regular price)
    def current_price
      on_sale? ? sale_price : price
    end
  end
  
  # To use this in your Product model:
  # include ProductHelpers