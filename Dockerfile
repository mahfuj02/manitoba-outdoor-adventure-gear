FROM ruby:3.2.2

# Install essential dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    npm \
    sqlite3 \
    libsass-dev \
    imagemagick

# Install Yarn for asset compilation
RUN npm install -g yarn

# Set working directory
WORKDIR /app

# Install the specific bundler version that matches your Gemfile.lock
RUN gem install bundler:2.6.3

# Copy Gemfile and install dependencies
COPY Gemfile Gemfile.lock ./

# Make sure we install ALL the gems
RUN bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]