// tailwind.config.js
module.exports = {
  content: [
    './app/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#1B5E41', // Dark forest green as primary color
          light: '#2D8C61',
          dark: '#0D3A25',
        },
        secondary: {
          DEFAULT: '#D4A72C', // Gold/amber as accent color
          light: '#F4D16A',
          dark: '#A67E1F',
        },
        neutral: {
          light: '#F5F5F0', // Off-white for backgrounds
          dark: '#2A2C2B',  // Almost black for text
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Montserrat', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ],
}