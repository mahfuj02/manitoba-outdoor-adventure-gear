# Start with the official Ruby image
FROM ruby:3.2.2

# Install essential dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    npm \
    sqlite3

# Install Yarn for asset compilation
RUN npm install -g yarn

# Set working directory
WORKDIR /app

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]