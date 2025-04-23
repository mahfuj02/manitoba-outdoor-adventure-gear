# app/admin/about_pages.rb
ActiveAdmin.register AboutPage do
    actions :all, except: [:destroy, :new]
    
    permit_params :content
    
    form do |f|
      f.inputs 'About Page Content' do
        f.input :content, as: :text, input_html: { rows: 10 }
      end
      f.actions
    end
    
    controller do
      def index
        AboutPage.first_or_create(content: 'About our outdoor adventure store...')
        super
      end
    end
  end