# app/controllers/about_controller.rb
class AboutController < ApplicationController
  def index
    @about = AboutPage.first_or_create(content: 'About our outdoor adventure store...')
  end
end

# app/controllers/contact_controller.rb
class ContactController < ApplicationController
  def index
    @contact = ContactPage.first_or_create(content: 'Contact information for our store...')
  end
end