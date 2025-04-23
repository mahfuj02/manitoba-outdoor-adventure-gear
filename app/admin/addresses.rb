# app/admin/addresses.rb
ActiveAdmin.register Address do
    # Permit these parameters to be edited through the admin interface
    permit_params :street, :city, :postal_code, :country, :province_id, :user_id, :is_default
  
    # Index page - listing all addresses
    index do
      selectable_column
      id_column
      column :street
      column :city
      column :province
      column :postal_code
      column :country
      column :user
      column :is_default
      actions
    end
  
    # Filter options in the sidebar
    filter :street
    filter :city
    filter :province
    filter :postal_code
    filter :country
    filter :user
    filter :is_default
  
    # Form for creating/editing addresses
    form do |f|
      f.inputs 'Address Details' do
        f.input :street
        f.input :city
        f.input :province
        f.input :postal_code
        f.input :country, priority_countries: ["CA"]
        f.input :user
        f.input :is_default
      end
      f.actions
    end
  
    # Show page - detailed view of an address
    show do
      attributes_table do
        row :id
        row :street
        row :city
        row :province
        row :postal_code
        row :country
        row :user
        row :is_default
        row :created_at
        row :updated_at
        row :full_address
      end
    end
  end