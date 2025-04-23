# app/admin/tags.rb
ActiveAdmin.register Tag do
    permit_params :name
    
    index do
      selectable_column
      id_column
      column :name
      column :products do |tag|
        tag.products.count
      end
      column :created_at
      actions
    end
    
    filter :name
    filter :created_at
    
    form do |f|
      f.inputs "Tag Details" do
        f.input :name
      end
      f.actions
    end
  end