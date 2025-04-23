# app/admin/provinces.rb
ActiveAdmin.register Province do
    # Permit these parameters to be edited through the admin interface
    permit_params :name, :code, :gst, :pst, :hst
  
    # Index page - listing all provinces
    index do
      selectable_column
      id_column
      column :name
      column :code
      column :gst do |province|
        number_to_percentage(province.gst, precision: 2)
      end
      column :pst do |province|
        number_to_percentage(province.pst, precision: 2)
      end
      column :hst do |province|
        number_to_percentage(province.hst, precision: 2)
      end
      column :total_tax do |province|
        number_to_percentage(province.tax_rate, precision: 2)
      end
      actions
    end
  
    # Filter options in the sidebar
    filter :name
    filter :code
    filter :gst
    filter :pst
    filter :hst
  
    # Form for creating/editing provinces
    form do |f|
      f.inputs 'Province Details' do
        f.input :name
        f.input :code
        f.input :gst, label: 'GST (%)', input_html: { min: 0, step: 0.01 }
        f.input :pst, label: 'PST (%)', input_html: { min: 0, step: 0.01 }
        f.input :hst, label: 'HST (%)', input_html: { min: 0, step: 0.01 }
      end
      f.actions
    end
  
    # Show page - detailed view of a province
    show do
      attributes_table do
        row :id
        row :name
        row :code
        row :gst do |province|
          number_to_percentage(province.gst, precision: 2)
        end
        row :pst do |province|
          number_to_percentage(province.pst, precision: 2)
        end
        row :hst do |province|
          number_to_percentage(province.hst, precision: 2)
        end
        row :total_tax do |province|
          number_to_percentage(province.tax_rate, precision: 2)
        end
        row :created_at
        row :updated_at
      end
  
      # Show addresses that belong to this province
      panel "Addresses in this Province" do
        table_for province.addresses do
          column :id
          column :street
          column :city
          column :postal_code
          column :country
          column :user
          column do |address|
            links = []
            links << link_to("View", admin_address_path(address))
            links << link_to("Edit", edit_admin_address_path(address))
            links.join(' | ').html_safe
          end
        end
      end
    end
  end