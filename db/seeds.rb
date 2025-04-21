# This seed file will populate the database with categories and products for
# Manitoba Outdoor Adventure Gear e-commerce store

# Add Faker gem to your Gemfile if not already present:
# gem 'faker'
# Then run: bundle install

require 'faker'

# Clear existing data to avoid duplicates in proper order to respect foreign key constraints
puts "Clearing existing data..."
# First, destroy join tables and dependent associations
CartItem.destroy_all if defined?(CartItem)
ProductTag.destroy_all if defined?(ProductTag)

# Next, destroy models that depend on others but aren't depended upon
# Check if these models exist before trying to destroy them
Order.destroy_all if defined?(Order)
OrderItem.destroy_all if defined?(OrderItem)
Review.destroy_all if defined?(Review)

# Then destroy the middle-level models
Cart.destroy_all if defined?(Cart)
Product.destroy_all 
Tag.destroy_all if defined?(Tag)

# Finally destroy the base models
Category.destroy_all

# Create categories
puts "Creating categories..."
categories = [
  { name: "Camping", description: "Essential gear for camping adventures in Manitoba's beautiful parks and wilderness areas." },
  { name: "Hiking", description: "Equipment for day hikes and multi-day treks through Manitoba's diverse landscapes." },
  { name: "Fishing", description: "Gear for fishing Manitoba's 100,000 lakes and rivers, from basic tackle to advanced equipment." },
  { name: "Hunting", description: "Specialized equipment for hunting seasons across Manitoba's varied terrains." },
  { name: "Outdoor Clothing", description: "Weather-appropriate clothing for all of Manitoba's seasons and outdoor activities." },
  { name: "Winter Gear", description: "Specialized equipment for Manitoba's harsh winter conditions, from snow sports to extreme cold protection." },
  { name: "Water Sports", description: "Equipment for kayaking, canoeing, paddle boarding, and other water activities on Manitoba's numerous lakes and rivers." }
]

category_objects = {}
categories.each do |category_data|
  category_objects[category_data[:name]] = Category.create!(
    name: category_data[:name],
    description: category_data[:description]
  )
end

puts "#{categories.length} categories created successfully!"

# Create tags for product filtering
puts "Creating tags..."
tag_names = [
  "On Sale", "New Arrival", "Best Seller", "Waterproof", 
  "Winter", "Summer", "Lightweight", "Premium"
]

tags = tag_names.map { |name| Tag.create!(name: name) }
puts "#{tags.length} tags created successfully!"

# Helper method to attach a random image to a product
def attach_random_image(product, category_name)
  # In a real implementation, you would have actual images to attach
  # This is just a placeholder for the functionality
  puts "Would attach image for #{product.name} in #{category_name} category"
end

# Helper method to add random tags to products - optimized to avoid database locks
def add_random_tags(product, tags)
  # Generate tag assignments without immediately saving to database
  tag_assignments = []
  tags.sample(rand(1..3)).each do |tag|
    tag_assignments << { product_id: product.id, tag_id: tag.id }
  end
  
  # Bulk insert in a single query if there are tags to assign
  if tag_assignments.any?
    ProductTag.insert_all(tag_assignments)
  end
end

# Generate product prefixes for more realistic names
product_prefixes = {
  "Camping" => ["Manitoba Explorer", "Prairie Night", "Wilderness", "Northern Lights", "Boreal"],
  "Hiking" => ["Trail Blazer", "Prairie Path", "Manitoba Trek", "Voyageur", "Backwoods"],
  "Fishing" => ["Manitoba Angler", "Great Lakes", "Prairie Waters", "Northern Catch", "Manitoba Ice"],
  "Hunting" => ["Manitoba Hunter", "Prairie Stalker", "North Woods", "Silent Track", "Outback"],
  "Outdoor Clothing" => ["Manitoba All-Season", "Prairie Hiker", "Northern", "Wilderness", "Explorer"],
  "Winter Gear" => ["Arctic", "Manitoba Winter", "Snow Walker", "Polar", "Frost"],
  "Water Sports" => ["Prairie River", "Manitoba Lake", "Northern Waters", "Great Lakes", "Wave Rider"]
}

# Generate product suffixes for more realistic names
product_suffixes = {
  "Camping" => ["Tent", "Sleeping Bag", "Cook Set", "Hammock", "Lantern", "Camp Chair", "Stove", "Shelter"],
  "Hiking" => ["Backpack", "Hiking Boots", "Trekking Poles", "Navigation Set", "First Aid Kit", "Hydration Pack"],
  "Fishing" => ["Fishing Rod", "Reel", "Tackle Box", "Fish Finder", "Fishing Vest", "Bait Kit", "Landing Net"],
  "Hunting" => ["Binoculars", "Hunting Blind", "Game Calls", "Hunting Pack", "Safety Vest", "Rangefinder"],
  "Outdoor Clothing" => ["Jacket", "Pants", "Base Layer", "Hat", "Socks", "Gloves", "Boots", "Rain Gear"],
  "Winter Gear" => ["Snowshoes", "Parka", "Hand Warmers", "Snow Pants", "Winter Boots", "Ice Grips", "Thermal Gear"],
  "Water Sports" => ["Kayak", "Paddle", "Life Jacket", "Dry Bag", "Water Shoes", "Wetsuit", "Float"]
}

# Generate product descriptions for more realistic content
description_prefixes = [
  "Premium quality", "Durable", "Lightweight", "Weather-resistant", 
  "Professional-grade", "Essential", "High-performance", "Versatile"
]

description_suffixes = [
  "perfect for Manitoba's outdoor conditions",
  "designed specifically for wilderness adventures",
  "ideal for outdoor enthusiasts in Manitoba",
  "built to withstand harsh Canadian environments",
  "perfect for exploring Manitoba's natural beauty",
  "essential gear for any outdoor adventure",
  "designed with the Manitoba explorer in mind"
]

# Create products (at least 100)
puts "Creating 100+ products across categories..."

# Process categories in batches to avoid database locks
total_products = 0
target_products = 105  # Aim for a bit more than 100 to be safe
products_per_category = (target_products / categories.length.to_f).ceil

categories.each do |category_data|
  category_name = category_data[:name]
  category = category_objects[category_name]
  
  # Create products in batches of 5 to avoid database locks
  (0...products_per_category).each_slice(5) do |batch_indices|
    batch_products = []
    
    batch_indices.each do |i|
      # Generate random product name
      prefix = product_prefixes[category_name].sample
      suffix = product_suffixes[category_name].sample
      name = "#{prefix} #{suffix}"
      
      # Add variation if needed to make unique
      name += " #{["Pro", "Elite", "Deluxe", "Lite", "Ultra"].sample}" if i % 5 == 0
      
      # Generate random description
      desc_prefix = description_prefixes.sample
      desc_suffix = description_suffixes.sample
      specific_feature = Faker::Lorem.sentence(word_count: 10)
      
      description = "#{desc_prefix} #{suffix.downcase} #{desc_suffix}. #{specific_feature}"
      
      # Generate random price between $15 and $500
      price = Faker::Commerce.price(range: 15..500.0)
      
      # Determine if on sale (approximately 30% of products)
      on_sale = Faker::Boolean.boolean(true_ratio: 0.3)
      sale_price = on_sale ? (price * Faker::Number.between(from: 0.7, to: 0.9)).round(2) : nil
      
      # Determine if new (approximately 25% of products)
      is_new = Faker::Boolean.boolean(true_ratio: 0.25)
      
      # Generate SKU
      sku = "#{category_name[0..3].upcase}-#{suffix[0..3].upcase}-#{Faker::Number.number(digits: 3)}"
      
      # Generate other product attributes
      stock_quantity = Faker::Number.between(from: 5, to: 50)
      weight = Faker::Number.decimal(l_digits: 1, r_digits: 1)
      
      # Generate dimensions
      dimensions = if ["Clothing", "Outdoor Clothing"].include?(category_name)
                     "Varies by size"
                   else
                     "#{Faker::Number.between(from: 5, to: 60)}\" x #{Faker::Number.between(from: 3, to: 24)}\" x #{Faker::Number.between(from: 2, to: 12)}\""
                   end
      
      # Add to batch
      batch_products << {
        name: name,
        description: description,
        price: price,
        sku: sku,
        stock_quantity: stock_quantity,
        weight: weight,
        dimensions: dimensions,
        on_sale: on_sale,
        sale_price: sale_price,
        is_new: is_new,
        category_id: category.id,
        created_at: Time.current,
        updated_at: Time.current
      }
    end
    
    # Insert all products in this batch in a single query
    created_products = Product.insert_all(batch_products, returning: %w[id name])
    
    # For logging purposes
    created_products.rows.each do |product_data|
      product_id = product_data[0]  # First column is ID
      product_name = product_data[1]  # Second column is name
      
      # Create a product object for passing to helper methods
      product = Product.new(id: product_id, name: product_name)
      
      # Log the image that would be attached
      puts "Would attach image for #{product_name} in #{category_name} category"
      
      # Add tags to this product
      add_random_tags(product, tags)
    end
    
    total_products += batch_products.size
    
    # Add a small sleep to give SQLite time to release locks
    sleep(0.1)
  end
end

puts "Seed data completed successfully!"
puts "Created #{Category.count} categories"
puts "Created #{Product.count} products"
puts "Created #{Tag.count} tags"
puts "Created #{ProductTag.count} product tags"