# app/admin/orders.rb
ActiveAdmin.register Order do
    # Basic permitted parameters
    permit_params :status
    
    # Basic index page without scopes or custom methods
    index do
      selectable_column
      id_column
      column :order_number
      column :user
      column :status
      column :total_amount do |order|
        number_to_currency(order.total_amount)
      end
      column :created_at
      actions
    end
    
    # Simple show page
    show do
      attributes_table do
        row :id
        row :order_number
        row :user
        row :status
        row :total_amount do |order|
          number_to_currency(order.total_amount)
        end
        row :tax_amount do |order|
          number_to_currency(order.tax_amount)
        end
        row :created_at
        row :updated_at
      end
    end
    
    # Basic form
    form do |f|
      f.inputs "Order Details" do
        f.input :status, as: :select, collection: Order.statuses.keys
      end
      f.actions
    end
  end