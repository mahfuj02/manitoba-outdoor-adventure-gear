# app/helpers/products_helper.rb
module ProductsHelper
    def product_image(product, options = {})
      if product.image.attached?
        image_tag product.image.variant(resize_to_limit: [300, 300]), options
      else
        image_tag 'placeholder.jpg', options
      end
    end
  end