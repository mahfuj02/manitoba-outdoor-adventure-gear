class AddSaleFieldsToProducts < ActiveRecord::Migration[7.2]
  def change
    # Check if on_sale column exists before adding it
    unless column_exists?(:products, :on_sale)
      add_column :products, :on_sale, :boolean, default: false
    end
    
    # Check if sale_price column exists before adding it
    unless column_exists?(:products, :sale_price)
      add_column :products, :sale_price, :decimal, precision: 8, scale: 2
    end
  end
end