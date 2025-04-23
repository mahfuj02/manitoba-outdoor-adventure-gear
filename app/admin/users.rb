# app/admin/users.rb
ActiveAdmin.register User do
    permit_params :email, :password, :password_confirmation, :first_name, :last_name, :phone
    
    index do
      selectable_column
      id_column
      column :email
      column :first_name
      column :last_name
      column :phone
      column :created_at
      actions
    end
    
    filter :email
    filter :first_name
    filter :last_name
    filter :phone
    filter :created_at
    
    form do |f|
      f.inputs do
        f.input :email
        f.input :first_name
        f.input :last_name
        f.input :phone
        f.input :password
        f.input :password_confirmation
      end
      f.actions
    end
    
    show do
      attributes_table do
        row :id
        row :email
        row :first_name
        row :last_name
        row :phone
        row :created_at
        row :updated_at
      end
    end
  end