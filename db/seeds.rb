# db/seeds.rb
if AdminUser.count == 0
    AdminUser.create!(
      email: 'admin@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    puts 'Default admin user created'
  end
  
  # Create categories
  categories = [
    {
      name: 'Camping Gear',
      description: 'Essential equipment for a comfortable camping experience in Manitoba\'s diverse outdoor environments.'
    },
    {
      name: 'Hiking Gear',
      description: 'Quality hiking equipment for exploring Manitoba\'s beautiful trails and landscapes.'
    },
    {
      name: 'Water Sports',
      description: 'Gear for enjoying Manitoba\'s numerous lakes and rivers.'
    },
    {
      name: 'Winter Adventure',
      description: 'Specialized equipment for Manitoba\'s snowy winter activities.'
    }
  ]
  
  categories.each do |category_data|
    Category.find_or_create_by!(name: category_data[:name]) do |category|
      category.description = category_data[:description]
      puts "Created category: #{category.name}"
    end
  end
  
  # Create content pages
  AboutPage.first_or_create do |about|
    about.content = <<~CONTENT
      # Manitoba Outdoor Adventure Gear
  
      Founded in 2023, Manitoba Outdoor Adventure Gear is your premier source for high-quality outdoor equipment designed specifically for Manitoba's unique landscapes and climate conditions.
  
      ## Our Mission
  
      We're dedicated to providing outdoor enthusiasts with reliable, durable gear that enhances their connection with Manitoba's natural beauty. Whether you're camping in Whiteshell Provincial Park, hiking the Spirit Sands, kayaking on Lake Winnipeg, or snowshoeing through Riding Mountain National Park, we have the equipment you need.
  
      ## Local Expertise
  
      Our team consists of passionate outdoor adventurers who have extensive experience exploring Manitoba's diverse environments. We personally test all our products in local conditions to ensure they meet our high standards of quality and performance.
    CONTENT
    puts "Created About page"
  end
  
  ContactPage.first_or_create do |contact|
    contact.content = <<~CONTENT
      # Contact Manitoba Outdoor Adventure Gear
  
      ## Store Location
      123 Adventure Avenue
      Winnipeg, MB R3C 0V8
  
      ## Hours
      Monday - Friday: 9:00 AM - 8:00 PM
      Saturday: 9:00 AM - 6:00 PM
      Sunday: 10:00 AM - 5:00 PM
  
      ## Contact Information
      Phone: (204) 555-0123
      Email: info@manitobaoutdoorgear.com
    CONTENT
    puts "Created Contact page"
  end
  
  # Create example products
  camping = Category.find_by(name: 'Camping Gear')
  hiking = Category.find_by(name: 'Hiking Gear')
  water = Category.find_by(name: 'Water Sports')
  winter = Category.find_by(name: 'Winter Adventure')
  
  products = [
    {
      name: 'Manitoba Explorer Tent',
      description: 'A spacious 4-person tent designed to withstand Manitoba\'s varying weather conditions. Features include a waterproof fly, strong aluminum poles, and mesh ventilation panels.',
      price: 249.99,
      stock_quantity: 15,
      category: camping,
      sku: 'TENT-001',
      weight: 3.5,
      dimensions: '120 x 210 x 150 cm'
    },
    {
      name: 'Prairie Trail Hiking Boots',
      description: 'Durable hiking boots with ankle support and water-resistant exterior, perfect for Manitoba\'s varied terrain and trails.',
      price: 149.99,
      stock_quantity: 22,
      category: hiking,
      sku: 'BOOT-001',
      weight: 0.9,
      dimensions: '30 x 15 x 12 cm'
    },
    {
      name: 'Winnipeg Voyageur Kayak',
      description: 'Stable, durable kayak perfect for exploring Manitoba\'s lakes and rivers. Includes storage compartments and adjustable seating.',
      price: 549.99,
      stock_quantity: 8,
      category: water,
      sku: 'KAYAK-001',
      weight: 21.5,
      dimensions: '330 x 75 x 35 cm'
    },
    {
      name: 'Northern Lights Snowshoes',
      description: 'Lightweight aluminum snowshoes with sturdy bindings, designed for traversing Manitoba\'s winter landscapes with ease.',
      price: 179.99,
      stock_quantity: 12,
      category: winter,
      sku: 'SNOW-001',
      weight: 2.2,
      dimensions: '82 x 25 x 5 cm'
    }
  ]
  
  products.each do |product_data|
    Product.find_or_create_by!(name: product_data[:name]) do |product|
      product.description = product_data[:description]
      product.price = product_data[:price]
      product.stock_quantity = product_data[:stock_quantity]
      product.category = product_data[:category]
      product.sku = product_data[:sku]
      product.weight = product_data[:weight]
      product.dimensions = product_data[:dimensions]
      puts "Created product: #{product.name}"
    end
  end