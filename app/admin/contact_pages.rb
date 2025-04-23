# app/admin/contact_pages.rb
ActiveAdmin.register ContactPage do
    actions :all, except: [:destroy, :new]
    
    permit_params :content
    
    form do |f|
      f.inputs 'Contact Page Content' do
        f.input :content, as: :text, input_html: { rows: 10 }
      end
      f.actions
    end
    
    controller do
      def index
        ContactPage.first_or_create(content: 'Contact information for our store...')
        super
      end
    end
  end