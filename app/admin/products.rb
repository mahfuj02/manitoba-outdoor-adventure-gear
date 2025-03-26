# app/admin/products.rb
ActiveAdmin.register Product do
  # Permit all parameters
  permit_params :name, :description, :sku, :price, :category_id, :weight, 
                :dimensions, :stock_quantity, :image

  # Index view
  index do
    selectable_column
    id_column
    column :name
    column :sku
    column :category
    column :price do |product|
      number_to_currency(product.price)
    end
    column :stock_quantity
    column :created_at
    actions
  end

  # Filters
  filter :name
  filter :sku
  filter :category
  filter :price
  filter :stock_quantity
  filter :created_at

  # Form
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description, as: :text
      f.input :sku
      f.input :price
      f.input :category
      f.input :weight
      f.input :dimensions
      f.input :stock_quantity
      f.input :image, as: :file
    end
    f.actions
  end

  # Show view
  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :sku
      row :category
      row :price do |product|
        number_to_currency(product.price)
      end
      row :weight
      row :dimensions
      row :stock_quantity
      row :created_at
      row :updated_at
      row :image do |product|
        if product.image.attached?
          image_tag product.image
        end
      end
    end
  end
end