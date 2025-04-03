# db/seeds.rb
# Add this to the end of your existing seeds file
require Rails.root.join('db', 'seeds', 'product_data_import')
Seeds::ProductDataImport.import_from_csv