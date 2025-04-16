class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :price_at_time_of_purchase, precision: 8, scale: 2, null: false
      t.decimal :subtotal, precision: 8, scale: 2

      t.timestamps
    end
  end
end