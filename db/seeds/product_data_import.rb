# db/seeds/product_data_import.rb
require 'csv'

module Seeds
  class ProductDataImport
    def self.import_from_csv
      # Path to the CSV file
      csv_file = Rails.root.join('db', 'seed_data', 'outdoor_products.csv')
      
      # Check if file exists
      unless File.exist?(csv_file)
        puts "CSV file not found: #{csv_file}"
        return
      end
      
      # Parse the CSV file
      products_data = []
      CSV.foreach(csv_file, headers: true) do |row|
        products_data << row.to_h
      end
      
      # Import the data
      products_imported = 0
      products_data.each do |product_data|
        # Find or create the category
        category = Category.find_or_create_by!(name: product_data['category']) do |cat|
          cat.description = "Products for #{product_data['category']}"
        end
        
        # Create the product
        product = Product.find_or_create_by(name: product_data['name']) do |p|
          p.description = product_data['description']
          p.price = product_data['price'].to_f
          p.stock_quantity = product_data['stock_quantity'].to_i
          p.sku = product_data['sku']
          p.weight = product_data['weight'].to_f if product_data['weight'].present?
          p.dimensions = product_data['dimensions'] if product_data['dimensions'].present?
          p.category = category
          
          products_imported += 1
        end
      end
      
      puts "Imported #{products_imported} products from CSV"
    end
  end
end