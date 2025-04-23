class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :sku
      t.decimal :price
      t.references :category, null: false, foreign_key: true
      t.decimal :weight
      t.string :dimensions
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
