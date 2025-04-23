class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :order_number, null: false
      t.datetime :order_date
      t.references :shipping_address, foreign_key: { to_table: :addresses }
      t.references :billing_address, foreign_key: { to_table: :addresses }
      t.integer :status, default: 0
      t.decimal :shipping_cost, precision: 8, scale: 2, default: 0
      t.decimal :tax_amount, precision: 8, scale: 2, default: 0
      t.decimal :total_amount, precision: 8, scale: 2, default: 0

      t.timestamps
    end
    
    add_index :orders, :order_number, unique: true
  end
end