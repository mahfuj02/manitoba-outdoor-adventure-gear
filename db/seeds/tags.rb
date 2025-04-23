# db/seeds/tags.rb
module Seeds
    class Tags
      def self.seed
        tags = [
          "Waterproof", "Lightweight", "Insulated", "All-Season", "Heavy-Duty", 
          "Portable", "Compact", "Durable", "Breathable", "Adjustable",
          "Professional", "Beginner", "Family", "Premium", "Budget-Friendly",
          "Manitoba-Made", "Eco-Friendly", "Cold Weather", "Hot Weather", "Rain Gear"
        ]
        
        tags.each do |tag_name|
          Tag.find_or_create_by!(name: tag_name)
          puts "Created tag: #{tag_name}"
        end
        
        # Assign random tags to products
        Product.all.each do |product|
          # Assign 2-4 random tags to each product
          random_tags = Tag.all.sample(rand(2..4))
          product.tags = random_tags
          puts "Assigned #{random_tags.map(&:name).join(', ')} tags to #{product.name}"
        end
      end
    end
  end