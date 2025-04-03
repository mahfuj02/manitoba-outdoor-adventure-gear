# app/admin/products.rb
ActiveAdmin.register Product do
  # Permit all parameters
  permit_params :name, :description, :price, :stock_quantity, :category_id, :image,
                :sku, :weight, :dimensions, :on_sale, :is_new, :sale_price

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
      
      f.inputs 'Filtering Options' do
        f.input :is_new, label: 'Mark as New Product'
        f.input :on_sale, label: 'On Sale'
        f.input :sale_price, label: 'Sale Price (if on sale)'
      end

      
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