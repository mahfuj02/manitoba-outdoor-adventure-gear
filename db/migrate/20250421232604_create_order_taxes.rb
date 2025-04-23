class CreateOrderTaxes < ActiveRecord::Migration[6.1]
  def change
    create_table :order_taxes do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :gst_rate, precision: 5, scale: 2, default: 0
      t.decimal :pst_rate, precision: 5, scale: 2, default: 0
      t.decimal :hst_rate, precision: 5, scale: 2, default: 0
      t.decimal :gst_amount, precision: 10, scale: 2, default: 0
      t.decimal :pst_amount, precision: 10, scale: 2, default: 0
      t.decimal :hst_amount, precision: 10, scale: 2, default: 0
      t.string :province_code
      t.string :province_name

      t.timestamps
    end
  end
end