# db/migrate/YYYYMMDDHHMMSS_add_filtering_fields_to_products.rb
class AddFilteringFieldsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :on_sale, :boolean, default: false
    add_column :products, :is_new, :boolean, default: true
    add_column :products, :sale_price, :decimal, precision: 8, scale: 2
  end
end