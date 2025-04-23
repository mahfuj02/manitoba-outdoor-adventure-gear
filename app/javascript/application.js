// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// app/javascript/application.js (or wherever your JavaScript is)
document.addEventListener('DOMContentLoaded', function() {
    // Update cart count after adding to cart
    const addToCartForm = document.querySelector('form[action*="/cart/add/"]');
    if (addToCartForm) {
      addToCartForm.addEventListener('submit', function() {
        // This is a simple way to update the UI - in a real application you might use
        // Turbo or fetch for a smoother experience
        setTimeout(function() {
          window.location.reload();
        }, 100);
      });
    }
  });